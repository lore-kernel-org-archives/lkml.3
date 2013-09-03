Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932612Ab3ICHmh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 03:42:37 -0400
Received: from ausxippc101.us.dell.com ([143.166.85.207]:44884 "EHLO
	ausxippc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932565Ab3ICHmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 03:42:36 -0400
X-LoopCount0: from 10.48.28.48
X-IronPort-AV: E=Sophos;i="4.89,1012,1367989200"; 
   d="scan'208";a="249012956"
Date: Tue, 3 Sep 2013 10:42:32 +0300
From: Menny Hamburger <Menny_Hamburger@Dell.com>
Message-Id: <201309030742.r837gW0g012535@bldhmenny.dell-idc.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] Per IP network statistics
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

For a while now, we have been testing a piece of code that maintains per-IP network statistics for diagnosing network problems.
I'm not sure if this idea as a whole or parts of it are viable for integration into mainline, so I'm sending it as is
(a set of patches over EL6.4 kernel). I would appreciate any feedback I can get on this - both idea wise and implementation specific.

Following is an overview on each patch in the series: 
1) SNMP MIB maps
     The SNMP counters are allocated per CPU (in EL code it is and also separated to bottom/top half), which makes their memory overhead quite high.
     In addition, for diagnosing network problems one doesn't always need all the counters. 
     An SNMP MIB map maintains a u8 array of mappings to the actual counters array,  where each entry in the mapping can hold either
     SNMP_MAP_UNMAPPED (255) or a valid index to the counters array. 
     The Linux MIB map for example in EL code looks roughly like this: 
     struct linux_mib_map {
         struct mapping {
             u8 mapping[__LINUX_MIB_MAX];
         };
         struct mapped {
             void *ptr[2];
         };
     }

     In the default situation, you want only the minimal set of counters to be allocated and updated, which serve as "red flags" for a network problem.
     Maintaining a small set of default counters is important both for performance reasons (less counters to update) and memory reasons
     (less counters to allocate). When a network problem comes up you will want to collect additional information in order to pin-point the cause. 
     By maintaining several levels of mappings for each SNMP MIB (each exposing a mutual exclusive set of counters), we can switch to a higher
     map level where more counters are updated. There are currently two map levels - default (0) and diagnostics (1), controlled by
     snmp_map_level (via a proc interface).

     As specified above, different levels hold a mutual exclusive set of counters, which enables us to maintain a one to one mapping of every counter
     in the MIB, to a specific mapping level. This feature is used in upper layers to determine the location of a specific counter so it can be
     accessed easily for update.

     Defining the mapping for an SNMP MIB is done via an exported function snmp_map_add_mapping (snmp_map_del_mapping for removing the mapping).
     specifying a NULL argument as the mapping to this function will collect all the counters not included in previous mapping levels,
     unless a counter is excluded specifically.

     Counter labels are registered using snmp_map_register_labels, which is invoked from ipv4/proc.c that already defines these.
     The current implementation only registers labels for TCP and LINUX MIBS since these are the only ones required by us.
     
2) Statistics hash tables: 
     The second layer is a set of hash tables to hold the counter information, where entries are hashed by source/destination address pair.
     An entry can be inserted/looked up in the hash table and the result is a cookie that can be stored for later use by some containing structure.
     struct stat_hash_cookie {
          struct {
                  u16 family;
                  u16 bucket;
          } hash;
         atomic_t seq;
      };
      When a cookie is not available, an entry can also be looked up by address, which adds some CPU cycles due to the use of jhash.
  
      Each entry contains the two mapping levels (0,1), where the actual per CPU counters are allocated on demand when inserting or looking
      up an existing entry, according to the value of snmp_map_level.
      Only TCP and LINUX MIB maps are currently defined, since we currently don't need any others. 
      Inserting an address into the hashtables can be done immediately or as a delayed job (for atomic insertion).
      For atomic insertion each entry is allocated with an extra piece of memory (freed when allocation is done), 
      required for scheduling delayed work - actual allocation is done there.   
     
      The implementation provides a proc interface for deleting all the entries in a hashtable, and zeroing a specified map level in all existing entries.
      When the hashtable is emptied, any lookup using an outdated cookie will cause the cookie to be "polluted" (it is assigned INT_MAX),
      which makes it unusable to its container. 
      
      The behavior of the hashtable can be controlled using proc interface, via /proc/sys/net/ipv4/perip_stats... and /proc/sys/net/ipv6/perip_stats...
      The IPV4 and IPV6 hashtable entries can be displayed via /proc/net/perip and /proc/net/perip6 respectively. 
      Data collection to the hashtable starts after calling an exported function stat_hash_start_data_collection (start_hash_stop_data_collection).

3) Socket API: 
      We chose to store a cookie inside "struct sock", in order to reduce the extra work needed by using jhash for finding the hash bucket.
      A set of STAT_HASH_SK_INSERT... macros where defined, that take a "struct sock *" as an argument, extract a pointer to the cookie, 
      extract the src/dst addresses, and call the hashtable insert function.
      There are two sets of insert macros: 
      a) Macros that allocate and insert a new entry into the hashtable if the address does not exist. 
         When the address exists (reuse), these macros extract the cookie and store it in the socket, possibly allocating additional map levels in the entry
         if snmp_map_level is higher than the mapping levels already allocated in the entry.
      b) Macros that look for an existing entry, possibly allocating additional map levels in the entry. 
         There is a specific "NOALLOC" macro that just looks for an existing entry, and does not do any allocations. 

      Different macros are defined for insertion at different locations in the code  (non-atomic context, atomic context, within spinlocks). 
      Although an address pair will only be added once to the hashtable, the insert macros test that the cookie contained in the socket is zero
      (has zero sequence number) before calling the insert code, so calling insert multiple times during the lifetime of a socket will do nothing.
      
      A set of macros were defined to replace the NET_INC..., TCP_INC macros, that perform the original work in addition to updating counters in the hashtable. 
      There are two sets of macros - one that takes a "stuct sock" as an argument (and uses the cookie to access the hashtable),
      and another set that takes a "struct sk_buff" as an argument and uses the source/destination address in the header for lookup via jhash.
      Before accessing the hash tables these macros first check if the specific counter we wish to update is defined in the current map level
      (snmp_map_level) using the mapping maintained by the SNMP map code - if it is not, no further processing is done.
  
      Sockets where the remote address is local to the machine, do not enter the hashtables by default because of the potential performance 
      overhead of updating their counters (specifically counters such as Insegs/Outsegs that are updated very frequently).
      A proc interface exists to enable adding loopback addresses to the hashtables.

4) Usage code: 
     atomic insert macros were added in accept and connect TCP paths (for both IP and IPV6). 
     An additional "NOALLOC" insert macro, was added to tcp_set_state so we don't miss any sockets. 

     Instead of modifying each and every NET/TCP macro call in the code, the original macros were overridden in ip.h/tcp.h by macros that that implicitly use "sk".
     Overriding the macros reduces the number of changes required in the code to those places where: 
     a) No access to either a socket or a socket buffer - use original macros (with __ prefix).
     b) No access to a socket, however a socket buffer is accessible - use socket buffer based macros. 
     c) The "struct variable" is not "sk" - use a macro that takes the name of the variable as an argument. 
     
A few TODO's: 
*) The code is missing documentation.
*) I haven't yet performed accurate measurements on the  performance impact of these changes (both in the default mode and diagnostics mode).
*) IPV6 statistics has only been verified, and not fully tested, so kernel compile time configuration and runtime configuration for IPV6 are both disabled by default.
*) Additional optimizations on fast paths.
*) Additional compile time configuration options for each one of the SNMP MIBs, so we can include statistics on other MIBs in a hash entry.

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Sample code for setting up the mappings and starting data collection: 


#include <net/ip.h>
#include <net/snmp_map.h>

static u8 tcp_stats[] = {
	TCP_MIB_ATTEMPTFAILS,
	TCP_MIB_ESTABRESETS,
	TCP_MIB_RETRANSSEGS,
}; 

/* Excluded because there is no access to a socket or a socket buffer in calls to update these counters */
static u8 tcp_exclude_stats[] = {
	TCP_MIB_RTOALGORITHM,
	TCP_MIB_RTOMIN,
	TCP_MIB_RTOMAX,
	TCP_MIB_MAXCONN,
}; 

static u8 linux_stats[] = {
	LINUX_MIB_TCPLOSS,
	LINUX_MIB_TCPLOSSFAILURES,
	LINUX_MIB_TCPSLOWSTARTRETRANS,
	LINUX_MIB_TCPTIMEOUTS,
	LINUX_MIB_TCPRCVCOLLAPSED,
	LINUX_MIB_TCPDSACKOLDSENT,
	LINUX_MIB_TCPDSACKRECV,
	LINUX_MIB_TCPABORTONDATA,
	LINUX_MIB_TCPABORTONCLOSE,
	LINUX_MIB_TCPABORTONTIMEOUT,
}; 

/* Excluded because there is no access to a socket or a socket buffer in calls to update these counters */ 
static linux_exclude_stats[] = {
	LINUX_MIB_ARPFILTER,
	LINUX_MIB_TCPMEMORYPRESSURES,
	LINUX_MIB_TIMEWAITED,
	LINUX_MIB_TIMEWAITKILLED,
	LINUX_MIB_TCPDSACKOLDSENT,
	LINUX_MIB_TCPDSACKOFOSENT,
}; 

static int __init perip_netstat_init(void) {
	... 
	If (snmp_map_add_mapping(SNMP_MAP_LEVEL_DEFAULT, SNMP_TCP_MIB,
			tcp_stats, sizeof(tcp_stats) / sizeof(u8), NULL, 0) < 0) { ... }
	if (snmp_map_add_mapping(SNMP_MAP_LEVEL_DIAG, SNMP_TCP_MIB, NULL, 0,
			tcp_exclude_stats, sizeof(tcp_exclude_stats) / sizeof(u8)) < 0) { ... }
     
	if (snmp_map_add_mapping(SNMP_MAP_LEVEL_DEFAULT, SNMP_LINUX_MIB,
			linux_stats, sizeof(linux_stats) / sizeof(u8), NULL, 0) < 0) {...}
	if (snmp_map_add_mapping(SNMP_MAP_LEVEL_DIAG, SNMP_ LINUX_MIB, NULL, 0,
			linux_exclude_stats, sizeof(linux_exclude_stats) / sizeof(u8)) < 0) {...}

	stat_hash_start_data_collection();
	... 
} 

Thanks
