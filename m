Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205Ab3BUSnf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 13:43:35 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:35226 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753876Ab3BUSnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 13:43:33 -0500
User-Agent: Microsoft-Entourage/12.35.0.121009
Date: Thu, 21 Feb 2013 18:43:23 +0000
Subject: Re: [PATCH XEN] xen: event channel arrays are xen_ulong_t and not
 unsigned long
From: Keir Fraser <keir.xen@gmail.com>
To: Ian Campbell <Ian.Campbell@citrix.com>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jan Beulich <JBeulich@suse.com>, "Keir (Xen.org)" <keir@xen.org>,
        "Tim (Xen.org)" <tim@xen.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Message-ID: <CD4C1B4B.4C72B%keir.xen@gmail.com>
Thread-Topic: [PATCH XEN] xen: event channel arrays are xen_ulong_t and not
 unsigned long
Thread-Index: Ac4QY1OObYhZzvCVl0eii+cpuFzYLg==
In-Reply-To: <1361466961.26546.85.camel@zakaz.uk.xensource.com>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/02/2013 17:16, "Ian Campbell" <Ian.Campbell@citrix.com> wrote:

> On Tue, 2013-02-19 at 14:49 +0000, Ian Campbell wrote:
>> On ARM we want these to be the same size on 32- and 64-bit.
>> 
>> This is an ABI change on ARM. X86 does not change.
>> 
>> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
>> Cc: Jan Beulich <JBeulich@suse.com>
>> Cc: Keir (Xen.org) <keir@xen.org>
> 
> Are you guys (un)happy with this change from the Xen & x86 side?

Fine by me.

 -- Keir

>> Cc: Tim Deegan <tim@xen.org>
>> Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
>> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>> Cc: linux-arm-kernel@lists.infradead.org
>> Cc: xen-devel@lists.xen.org
>> ---
>>  tools/include/xen-foreign/mkheader.py |    6 ++++++
>>  xen/include/public/xen.h              |    8 ++++----
>>  2 files changed, 10 insertions(+), 4 deletions(-)
>> 
>> diff --git a/tools/include/xen-foreign/mkheader.py
>> b/tools/include/xen-foreign/mkheader.py
>> index d189b07..57681fa 100644
>> --- a/tools/include/xen-foreign/mkheader.py
>> +++ b/tools/include/xen-foreign/mkheader.py
>> @@ -21,13 +21,18 @@ inttypes["arm"] = {
>>      "unsigned long" : "uint32_t",
>>      "long"          : "uint32_t",
>>      "xen_pfn_t"     : "uint64_t",
>> +    "xen_ulong_t"   : "uint64_t",
>>  };
>> +header["arm"] = """
>> +#define __arm___ARM32 1
>> +""";
>>  
>>  # x86_32
>>  inttypes["x86_32"] = {
>>      "unsigned long" : "uint32_t",
>>      "long"          : "uint32_t",
>>      "xen_pfn_t"     : "uint32_t",
>> +    "xen_ulong_t"   : "uint32_t",
>>  };
>>  header["x86_32"] = """
>>  #define __i386___X86_32 1
>> @@ -42,6 +47,7 @@ inttypes["x86_64"] = {
>>      "unsigned long" : "__align8__ uint64_t",
>>      "long"          : "__align8__ uint64_t",
>>      "xen_pfn_t"     : "__align8__ uint64_t",
>> +    "xen_ulong_t"   : "__align8__ uint64_t",
>>  };
>>  header["x86_64"] = """
>>  #if defined(__GNUC__) && !defined(__STRICT_ANSI__)
>> diff --git a/xen/include/public/xen.h b/xen/include/public/xen.h
>> index 5593066..99c8212 100644
>> --- a/xen/include/public/xen.h
>> +++ b/xen/include/public/xen.h
>> @@ -556,7 +556,7 @@ DEFINE_XEN_GUEST_HANDLE(multicall_entry_t);
>>   * Event channel endpoints per domain:
>>   *  1024 if a long is 32 bits; 4096 if a long is 64 bits.
>>   */
>> -#define NR_EVENT_CHANNELS (sizeof(unsigned long) * sizeof(unsigned long) *
>> 64)
>> +#define NR_EVENT_CHANNELS (sizeof(xen_ulong_t) * sizeof(xen_ulong_t) * 64)
>>  
>>  struct vcpu_time_info {
>>      /*
>> @@ -613,7 +613,7 @@ struct vcpu_info {
>>       */
>>      uint8_t evtchn_upcall_pending;
>>      uint8_t evtchn_upcall_mask;
>> -    unsigned long evtchn_pending_sel;
>> +    xen_ulong_t evtchn_pending_sel;
>>      struct arch_vcpu_info arch;
>>      struct vcpu_time_info time;
>>  }; /* 64 bytes (x86) */
>> @@ -663,8 +663,8 @@ struct shared_info {
>>       * per-vcpu selector word to be set. Each bit in the selector covers a
>>       * 'C long' in the PENDING bitfield array.
>>       */
>> -    unsigned long evtchn_pending[sizeof(unsigned long) * 8];
>> -    unsigned long evtchn_mask[sizeof(unsigned long) * 8];
>> +    xen_ulong_t evtchn_pending[sizeof(xen_ulong_t) * 8];
>> +    xen_ulong_t evtchn_mask[sizeof(xen_ulong_t) * 8];
>>  
>>      /*
>>       * Wallclock time: updated only by control software. Guests should base
> 
> 


