Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760083Ab3BZCGl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 21:06:41 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:63042 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388Ab3BZCGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 21:06:38 -0500
MIME-Version: 1.0
In-Reply-To: <CAE9FiQXs3MyUW+hJhupJgL-t9sYmT5GdeStWD2vMjsJG+6qCrQ@mail.gmail.com>
References: <512B7D10.4060304@tpi.com>
	<512B8407.2090807@canonical.com>
	<512BD753.4080001@hp.com>
	<CAE9FiQVY4io_mO3PhTtE6FbGUgo1uZKKXO=pjx_FoZ1JuZmsAw@mail.gmail.com>
	<CAE9FiQXs3MyUW+hJhupJgL-t9sYmT5GdeStWD2vMjsJG+6qCrQ@mail.gmail.com>
Date: Mon, 25 Feb 2013 18:06:38 -0800
X-Google-Sender-Auth: RnWLcfwkdO6hrRwx7KaDrNaN_Uw
Message-ID: <CAE9FiQXHNm+E+PchPsReOykVPNkRrC8ttjDpWWs=njANT+Wf1Q@mail.gmail.com>
Subject: Re: sched: CPU #1's llc-sibling CPU #0 is not on the same node!
From: Yinghai Lu <yinghai@kernel.org>
To: Don Morris <don.morris@hp.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>, mbligh@mbligh.org
Cc: Tim Gardner <tim.gardner@canonical.com>, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        a.p.zijlstra@chello.nl, jarkko.sakkinen@intel.com,
        tangchen@cn.fujitsu.com
Content-Type: multipart/mixed; boundary=14dae93411b99b90e604d6971bb8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--14dae93411b99b90e604d6971bb8
Content-Type: text/plain; charset=ISO-8859-1

[ Add new address with Martin]

On Mon, Feb 25, 2013 at 4:35 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Mon, Feb 25, 2013 at 2:50 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> On Mon, Feb 25, 2013 at 1:27 PM, Don Morris <don.morris@hp.com> wrote:
>>> On 02/25/2013 10:32 AM, Tim Gardner wrote:
>>>> On 02/25/2013 08:02 AM, Tim Gardner wrote:
>>>>> Is this an expected warning ? I'll boot a vanilla kernel just to be sure.
>>>>>
>>>>> rebased against ab7826595e9ec51a51f622c5fc91e2f59440481a in Linus' repo:
>>>>>
>>>>
>>>> Same with a vanilla kernel, so it doesn't appear that any Ubuntu cruft
>>>> is having an impact:
>>>
>>> Reproduced on a HP z620 workstation (E5-2620 instead of E5-2680, but
>>> still Sandy Bridge, though I don't think that matters).
>>>
>>> Bisection leads to:
>>> # bad: [e8d1955258091e4c92d5a975ebd7fd8a98f5d30f] acpi, memory-hotplug:
>>> parse SRAT before memblock is ready
>>>
>>> Nothing terribly obvious leaps out as to *why* that reshuffling messes
>>> up the cpu<-->node bindings, but I wanted to put this out there while
>>> I poke around further. [Note that the SRAT: PXM -> APIC -> Node print
>>> outs during boot are the same either way -- if you look at the APIC
>>> numbers of the processors (from /proc/cpuinfo), the processors should
>>> be assigned to the correct node, but they aren't.] cc'ing Tang Chen
>>> in case this is obvious to him or he's already fixed it somewhere not
>>> on Linus's tree yet.
>>>
>>> Don Morris
>>>
>>>>
>>>> [    0.170435] ------------[ cut here ]------------
>>>> [    0.170450] WARNING: at arch/x86/kernel/smpboot.c:324
>>>> topology_sane.isra.2+0x71/0x84()
>>>> [    0.170452] Hardware name: S2600CP
>>>> [    0.170454] sched: CPU #1's llc-sibling CPU #0 is not on the same
>>>> node! [node: 1 != 0]. Ignoring dependency.
>>>> [    0.156000] smpboot: Booting Node   1, Processors  #1
>>>> [    0.170455] Modules linked in:
>>>> [    0.170460] Pid: 0, comm: swapper/1 Not tainted 3.8.0+ #1
>>>> [    0.170461] Call Trace:
>>>> [    0.170466]  [<ffffffff810597bf>] warn_slowpath_common+0x7f/0xc0
>>>> [    0.170473]  [<ffffffff810598b6>] warn_slowpath_fmt+0x46/0x50
>>>> [    0.170477]  [<ffffffff816cc752>] topology_sane.isra.2+0x71/0x84
>>>> [    0.170482]  [<ffffffff816cc9de>] set_cpu_sibling_map+0x23f/0x436
>>>> [    0.170487]  [<ffffffff816ccd0c>] start_secondary+0x137/0x201
>>>> [    0.170502] ---[ end trace 09222f596307ca1d ]---
>>
>> that commit is totally broken, and it should be reverted.
>>
>> 1. numa_init is called several times, NOT just for srat. so those
>>    nodes_clear(numa_nodes_parsed)
>>    memset(&numa_meminfo, 0, sizeof(numa_meminfo))
>> can not be just removed.
>> please consider sequence is: numaq, srat, amd, dummy.
>> You need to make fall back path working!
>>
>> 2. simply split acpi_numa_init to early_parse_srat.
>> a. that early_parse_srat is NOT called for ia64, so you break ia64.
>> b.  for (i = 0; i < MAX_LOCAL_APIC; i++)
>>      set_apicid_to_node(i, NUMA_NO_NODE)
>> still left in numa_init. So it will just clear result from early_parse_srat.
>> it should be moved before that....
>>
>> 3. that patch TITLE is total misleading, there is NO x86 in the title,
>> but it changes
>> to x86 code.
>>
>> 4, it does not CC to TJ and other numa guys...
>
> attached workaround the problem for now.
> but it will assume NUMAQ would not have SRAT table.
>

 Martin, can you confirm that numaq does not have srat?

Thanks

Yinghai

--14dae93411b99b90e604d6971bb8
Content-Type: application/octet-stream; name="x.patch"
Content-Disposition: attachment; filename="x.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hdmezovd1

LS0tCiBhcmNoL2lhNjQva2VybmVsL3NldHVwLmMgfCAgICAxICsKIGFyY2gveDg2L2tlcm5lbC9z
ZXR1cC5jICB8ICAgIDQgKysrKwogYXJjaC94ODYvbW0vbnVtYS5jICAgICAgIHwgICAxMyArKysr
KysrKysrLS0tCiAzIGZpbGVzIGNoYW5nZWQsIDE1IGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25z
KC0pCgpJbmRleDogbGludXgtMi42L2FyY2gveDg2L2tlcm5lbC9zZXR1cC5jCj09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0K
LS0tIGxpbnV4LTIuNi5vcmlnL2FyY2gveDg2L2tlcm5lbC9zZXR1cC5jCisrKyBsaW51eC0yLjYv
YXJjaC94ODYva2VybmVsL3NldHVwLmMKQEAgLTgwOSw2ICs4MDksOCBAQCBzdGF0aWMgdm9pZCBf
X2luaXQgdHJpbV9sb3dfbWVtb3J5X3JhbmdlCiAKIHZvaWQgX19pbml0IHNldHVwX2FyY2goY2hh
ciAqKmNtZGxpbmVfcCkKIHsKKwlpbnQgaTsKKwogCW1lbWJsb2NrX3Jlc2VydmUoX19wYV9zeW1i
b2woX3RleHQpLAogCQkJICh1bnNpZ25lZCBsb25nKV9fYnNzX3N0b3AgLSAodW5zaWduZWQgbG9u
ZylfdGV4dCk7CiAKQEAgLTEwNjMsNiArMTA2NSw4IEBAIHZvaWQgX19pbml0IHNldHVwX2FyY2go
Y2hhciAqKmNtZGxpbmVfcCkKIAkgKi8KIAlhY3BpX2Jvb3RfdGFibGVfaW5pdCgpOwogCWVhcmx5
X2FjcGlfYm9vdF9pbml0KCk7CisJZm9yIChpID0gMDsgaSA8IE1BWF9MT0NBTF9BUElDOyBpKysp
CisJCXNldF9hcGljaWRfdG9fbm9kZShpLCBOVU1BX05PX05PREUpOwogCWVhcmx5X3BhcnNlX3Ny
YXQoKTsKIAogI2lmZGVmIENPTkZJR19YODZfMzIKSW5kZXg6IGxpbnV4LTIuNi9hcmNoL3g4Ni9t
bS9udW1hLmMKPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PQotLS0gbGludXgtMi42Lm9yaWcvYXJjaC94ODYvbW0vbnVtYS5j
CisrKyBsaW51eC0yLjYvYXJjaC94ODYvbW0vbnVtYS5jCkBAIC01NTYsOSArNTU2LDYgQEAgc3Rh
dGljIGludCBfX2luaXQgbnVtYV9pbml0KGludCAoKmluaXRfZgogCWludCBpOwogCWludCByZXQ7
CiAKLQlmb3IgKGkgPSAwOyBpIDwgTUFYX0xPQ0FMX0FQSUM7IGkrKykKLQkJc2V0X2FwaWNpZF90
b19ub2RlKGksIE5VTUFfTk9fTk9ERSk7Ci0KIAkvKgogCSAqIERvIG5vdCBjbGVhciBudW1hX25v
ZGVzX3BhcnNlZCBvciB6ZXJvIG51bWFfbWVtaW5mbyBoZXJlLCBiZWNhdXNlCiAJICogU1JBVCB3
YXMgcGFyc2VkIGVhcmxpZXIgaW4gZWFybHlfcGFyc2Vfc3JhdCgpLgpAQCAtNjI0LDYgKzYyMSw4
IEBAIHN0YXRpYyBpbnQgX19pbml0IGR1bW15X251bWFfaW5pdCh2b2lkKQogICovCiB2b2lkIF9f
aW5pdCB4ODZfbnVtYV9pbml0KHZvaWQpCiB7CisJaW50IGk7CisKIAlpZiAoIW51bWFfb2ZmKSB7
CiAjaWZkZWYgQ09ORklHX1g4Nl9OVU1BUQogCQlpZiAoIW51bWFfaW5pdChudW1hcV9udW1hX2lu
aXQpKQpAQCAtNjM0LDExICs2MzMsMTkgQEAgdm9pZCBfX2luaXQgeDg2X251bWFfaW5pdCh2b2lk
KQogCQkJcmV0dXJuOwogI2VuZGlmCiAjaWZkZWYgQ09ORklHX0FNRF9OVU1BCisJCWZvciAoaSA9
IDA7IGkgPCBNQVhfTE9DQUxfQVBJQzsgaSsrKQorCQkJc2V0X2FwaWNpZF90b19ub2RlKGksIE5V
TUFfTk9fTk9ERSk7CisJCW5vZGVzX2NsZWFyKG51bWFfbm9kZXNfcGFyc2VkKTsKKwkJbWVtc2V0
KCZudW1hX21lbWluZm8sIDAsIHNpemVvZihudW1hX21lbWluZm8pKTsKIAkJaWYgKCFudW1hX2lu
aXQoYW1kX251bWFfaW5pdCkpCiAJCQlyZXR1cm47CiAjZW5kaWYKIAl9CiAKKwlmb3IgKGkgPSAw
OyBpIDwgTUFYX0xPQ0FMX0FQSUM7IGkrKykKKwkJc2V0X2FwaWNpZF90b19ub2RlKGksIE5VTUFf
Tk9fTk9ERSk7CisJbm9kZXNfY2xlYXIobnVtYV9ub2Rlc19wYXJzZWQpOworCW1lbXNldCgmbnVt
YV9tZW1pbmZvLCAwLCBzaXplb2YobnVtYV9tZW1pbmZvKSk7CiAJbnVtYV9pbml0KGR1bW15X251
bWFfaW5pdCk7CiB9CiAKSW5kZXg6IGxpbnV4LTIuNi9hcmNoL2lhNjQva2VybmVsL3NldHVwLmMK
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PQotLS0gbGludXgtMi42Lm9yaWcvYXJjaC9pYTY0L2tlcm5lbC9zZXR1cC5jCisr
KyBsaW51eC0yLjYvYXJjaC9pYTY0L2tlcm5lbC9zZXR1cC5jCkBAIC01NTgsNiArNTU4LDcgQEAg
c2V0dXBfYXJjaCAoY2hhciAqKmNtZGxpbmVfcCkKIAlhY3BpX3RhYmxlX2luaXQoKTsKIAllYXJs
eV9hY3BpX2Jvb3RfaW5pdCgpOwogIyBpZmRlZiBDT05GSUdfQUNQSV9OVU1BCisJZWFybHlfcGFy
c2Vfc3JhdCgpOwogCWFjcGlfbnVtYV9pbml0KCk7CiAjICBpZmRlZiBDT05GSUdfQUNQSV9IT1RQ
TFVHX0NQVQogCXByZWZpbGxfcG9zc2libGVfbWFwKCk7Cg==
--14dae93411b99b90e604d6971bb8--
