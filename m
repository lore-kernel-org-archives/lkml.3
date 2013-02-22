Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448Ab3BVILN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 03:11:13 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:34727 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076Ab3BVILL convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:6:1>);
	Fri, 22 Feb 2013 03:11:11 -0500
Message-Id: <5127366502000078000C0380@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.1 
Date: Fri, 22 Feb 2013 08:12:05 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Ian Campbell" <Ian.Campbell@citrix.com>
Cc: "Stefano Stabellini" <Stefano.Stabellini@eu.citrix.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Keir (Xen.org)" <keir@xen.org>, "Tim(Xen.org)" <tim@xen.org>
Subject: Re: [PATCH XEN] xen: event channel arrays are xen_ulong_t and
 not unsigned long
References: <1361285327.1051.115.camel@zakaz.uk.xensource.com>
 <1361285363-27133-1-git-send-email-ian.campbell@citrix.com>
 <1361466961.26546.85.camel@zakaz.uk.xensource.com>
In-Reply-To: <1361466961.26546.85.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 21.02.13 at 18:16, Ian Campbell <Ian.Campbell@citrix.com> wrote:
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

I don't see any problem with it.

Jan

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
> b/tools/include/xen-foreign/mkheader.py
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
> 64)
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



