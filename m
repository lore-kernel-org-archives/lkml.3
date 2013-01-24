Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286Ab3AXSoj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 13:44:39 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:1057 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190Ab3AXSoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 13:44:34 -0500
Message-ID: <51018110.1070403@hp.com>
Date: Thu, 24 Jan 2013 10:44:32 -0800
From: Rick Jones <rick.jones2@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Leandro Lucarella <leandro.lucarella@sociomantic.com>
CC: Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Doubts about listen backlog and tcp_max_syn_backlog
References: <20130122161038.GG4608@sociomantic.com> <1358873142.3464.3964.camel@edumazet-glaptop> <20130122165929.GH4608@sociomantic.com> <1358874800.3464.4002.camel@edumazet-glaptop> <50FED7CE.1030008@hp.com> <20130122184245.GJ4608@sociomantic.com> <50FF0C25.9000300@hp.com> <20130123104736.GK4608@sociomantic.com> <510039C8.7040401@hp.com> <20130124122223.GQ4608@sociomantic.com>
In-Reply-To: <20130124122223.GQ4608@sociomantic.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/24/2013 04:22 AM, Leandro Lucarella wrote:
> On Wed, Jan 23, 2013 at 11:28:08AM -0800, Rick Jones wrote:
>>> Then if syncookies are enabled, the time spent in connect() shouldn't be
>>> bigger than 3 seconds even if SYNs are being "dropped" by listen, right?
>>
>> Do you mean if "ESTABLISHED" connections are dropped because the
>> listen queue is full?  I don't think I would put that as "SYNs being
>> dropped by listen" - too easy to confuse that with an actual
>> dropping of a SYN segment.
>
> I was just kind of quoting the name given by netstat: "SYNs to LISTEN
> sockets dropped" (for kernel 3.0, I noticed newer kernels don't have
> this stat anymore, or the name was changed). I still don't know if we
> are talking about the same thing.

Are you sure those stats are not present in 3.X kernels?  I just looked 
at /proc/net/netstat on a 3.7 system and noticed both the ListenMumble 
stats and the three cookie stats.  And I see the code for them in the tree:

aj@tardy:~/net-next/net/ipv4$ grep MIB_LISTEN *.c
proc.c:	SNMP_MIB_ITEM("ListenOverflows", LINUX_MIB_LISTENOVERFLOWS),
proc.c:	SNMP_MIB_ITEM("ListenDrops", LINUX_MIB_LISTENDROPS),
tcp_ipv4.c:	NET_INC_STATS_BH(sock_net(sk), LINUX_MIB_LISTENOVERFLOWS);
tcp_ipv4.c:	NET_INC_STATS_BH(sock_net(sk), LINUX_MIB_LISTENDROPS);

raj@tardy:~/net-next/net/ipv4$ grep MIB_SYN *.c
proc.c:	SNMP_MIB_ITEM("SyncookiesSent", LINUX_MIB_SYNCOOKIESSENT),
proc.c:	SNMP_MIB_ITEM("SyncookiesRecv", LINUX_MIB_SYNCOOKIESRECV),
proc.c:	SNMP_MIB_ITEM("SyncookiesFailed", LINUX_MIB_SYNCOOKIESFAILED),
syncookies.c:	NET_INC_STATS_BH(sock_net(sk), LINUX_MIB_SYNCOOKIESSENT);
syncookies.c:		NET_INC_STATS_BH(sock_net(sk), LINUX_MIB_SYNCOOKIESFAILED);
syncookies.c:	NET_INC_STATS_BH(sock_net(sk), LINUX_MIB_SYNCOOKIESRECV);


I will sometimes be tripped-up by netstat's not showing a statistic with 
a zero value...

>> But yes, I would not expect a connect() call to remain incomplete
>> for any longer than it took to receive an SYN|ACK from the other
>> end.
>
> So the only reason to experience these high times spent in connect()
> should be because a SYN or SYN|ACK was actually loss in a lower layer,
> like an error in the network device or a transmission error?

Modulo the/some other drop-without-stat point such as Vijay mentioned 
yesterday.

You might consider taking some packet traces.  If you can I would start 
with a trace taken on the system(s) on which the long connect() calls 
are happening.   I think the tcpdump manpage has an example of a tcpdump 
command with a filter expression that catches just SYNchronize and 
FINished segments which I suppose you could extend to include ReSeT 
segments.  Such a filter expression would be missing the client's ACK of 
the SYN|ACK but unless you see incrementing stats relating to say 
checksum failures or other drops on the "client" side I suppose you 
could assume that the client ACKed the server's SYN|ACK.

>> That would be 3 (,9, 21, etc...) seconds on a kernel with 3
>> seconds as the initial retransmission timeout.
>
> Which can't be changed without recompiling, right?

To the best of my knowledge.

rick jones
