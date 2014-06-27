Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589AbaF0Dgz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 23:36:55 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:59746 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752450AbaF0Dgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 23:36:51 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.10.1406212306540.5170@nanos>
References: <1402302011-23642-1-git-send-email-jiang.liu@linux.intel.com>
	<alpine.DEB.2.10.1406212306540.5170@nanos>
Date: Thu, 26 Jun 2014 20:36:49 -0700
X-Google-Sender-Auth: Wi3uJj77_K20RFbh4j7VdOkuEYc
Message-ID: <CAE9FiQVUK_oCEfKhHiM496oc+U6UcM0afPdR_sjQcObMzBjW2A@mail.gmail.com>
Subject: Re: [Patch V4 00/42] use irqdomain to dynamically allocate IRQ for IOAPIC
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Grant Likely <grant.likely@linaro.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Content-Type: multipart/mixed; boundary=089e0129478405ac1404fcc90532
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--089e0129478405ac1404fcc90532
Content-Type: text/plain; charset=UTF-8

On Sat, Jun 21, 2014 at 2:08 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> Jiang,
>
> On Mon, 9 Jun 2014, Jiang Liu wrote:
>
>> On x86 platforms, IRQ number are statically allocated to IOAPIC pins at boot.
>> There are two issues with this design. First it causes trouble to IOAPIC
>> hotplug because we need to allocate a block of IRQ numbers for each IOAPIC.
>> Second it may waste IRQ nubmers even if some IOAPIC pins are not used because
>> IRQ numbers are statically assigned.
>>
>> This patchset tries to enable dynamic IRQ number allocation for IOAPIC
>> by adopting the irqdomain framework, it solves the two issues mentioned
>> above. It also simplifies the IOAPIC driver by consolidating ways to
>> program IOAPIC pins with the irqdomain map interface.
>>
>> We will enhance the IOAPIC driver core to support ACPI based IOAPIC hotplug
>> once the IOAPIC driver has been converted to irqdomain.
>
> I merged the whole lot. Thanks for doing this and reacting on all the
> review comments. Very nice cleanup work!
>

I got following warning on RHEL 7.0 shutdown path.

[58018.128900] ------------[ cut here ]------------
[58018.134081] WARNING: CPU: 21 PID: 1 at fs/proc/generic.c:521
remove_proc_entry+0x150/0x1a0()
[58018.143596] remove_proc_entry: removing non-empty directory
'irq/23', leaking at least 'ehci_hcd:usb2'
[58018.154001] Modules linked in:
[58018.157435] CPU: 21 PID: 1 Comm: systemd-shutdow Tainted: G
W     3.16.0-rc2-yh-00420-g6d62036-dirty #36
[58018.168716] Hardware name: Oracle Corporation ORACLE SERVER
[58018.179703]  0000000000000009 ffff885e759bfb60 ffffffff81f76520
ffff885e759bfba8
[58018.188033]  ffff885e759bfb98 ffffffff8109d03d ffff88edf9fb9f00
0000000000000002
[58018.196358]  ffff885e759bfc6e ffff88f07b3f4330 ffff88edf9fb9fb9
ffff885e759bfbf8
[58018.204682] Call Trace:
[58018.207432]  [<ffffffff81f76520>] dump_stack+0x45/0x56
[58018.213186]  [<ffffffff8109d03d>] warn_slowpath_common+0x7d/0xa0
[58018.219903]  [<ffffffff8109d0ac>] warn_slowpath_fmt+0x4c/0x50
[58018.226336]  [<ffffffff8124b830>] remove_proc_entry+0x150/0x1a0
[58018.232963]  [<ffffffff810fdb5f>] unregister_irq_proc+0xbf/0xd0
[58018.239589]  [<ffffffff810f7b41>] free_desc+0x31/0xa0
[58018.245240]  [<ffffffff810f7c1c>] irq_free_descs+0x6c/0x80
[58018.251375]  [<ffffffff810fd2e3>] irq_dispose_mapping+0x53/0x60
[58018.258011]  [<ffffffff81083d60>] mp_unmap_irq+0xa0/0xc0
[58018.263960]  [<ffffffff8107ac8f>] acpi_unregister_gsi_ioapic+0x2f/0x40
[58018.271263]  [<ffffffff8107ab17>] acpi_unregister_gsi+0x17/0x20
[58018.277896]  [<ffffffff815a4562>] acpi_pci_irq_disable+0x5e/0x68
[58018.284619]  [<ffffffff81e33680>] pcibios_disable_device+0x20/0x30
[58018.291536]  [<ffffffff81557222>] do_pci_disable_device+0x52/0x60
[58018.298350]  [<ffffffff815572c2>] pci_disable_device+0x92/0xb0
[58018.304876]  [<ffffffff81c710bf>] usb_hcd_pci_shutdown+0x3f/0x50
[58018.311593]  [<ffffffff81559666>] pci_device_shutdown+0x36/0x70
[58018.318220]  [<ffffffff817a4875>] device_shutdown+0x135/0x190
[58018.324651]  [<ffffffff810bd935>] kernel_power_off+0x35/0x80
[58018.330980]  [<ffffffff810bdc33>] SyS_reboot+0x233/0x260
[58018.336919]  [<ffffffff810de239>] ? cpuacct_account_field+0x99/0xb0
[58018.343929]  [<ffffffff810de1a5>] ? cpuacct_account_field+0x5/0xb0
[58018.350843]  [<ffffffff81f86327>] ? _raw_spin_unlock+0x27/0x30
[58018.357378]  [<ffffffff810e3446>] ? trace_hardirqs_on_caller+0x16/0x260
[58018.364774]  [<ffffffff810e369d>] ? trace_hardirqs_on+0xd/0x10
[58018.371302]  [<ffffffff8105c83c>] ? syscall_trace_enter+0x17c/0x1c0
[58018.378312]  [<ffffffff81f870aa>] tracesys+0xd4/0xd9
[58018.383867] ---[ end trace fade991312a6a2d9 ]---
[58018.389026]   free irq_desc for 23

Like to suggest attached patch that skip mp_unregister_gsi on shutdown path.

Thanks

Yinghai

--089e0129478405ac1404fcc90532
Content-Type: text/x-patch; charset=US-ASCII; name="free_irq_hcd_pci.patch"
Content-Disposition: attachment; filename="free_irq_hcd_pci.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hwwy2h530

LS0tCiBhcmNoL3g4Ni9rZXJuZWwvYWNwaS9ib290LmMgfCAgICA2ICsrKysrKwogMSBmaWxlIGNo
YW5nZWQsIDYgaW5zZXJ0aW9ucygrKQoKSW5kZXg6IGxpbnV4LTIuNi9hcmNoL3g4Ni9rZXJuZWwv
YWNwaS9ib290LmMKPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PQotLS0gbGludXgtMi42Lm9yaWcvYXJjaC94ODYva2VybmVs
L2FjcGkvYm9vdC5jCisrKyBsaW51eC0yLjYvYXJjaC94ODYva2VybmVsL2FjcGkvYm9vdC5jCkBA
IC02NTksNiArNjU5LDEyIEBAIHN0YXRpYyBpbnQgYWNwaV9yZWdpc3Rlcl9nc2lfaW9hcGljKHN0
cnUKIHN0YXRpYyB2b2lkIGFjcGlfdW5yZWdpc3Rlcl9nc2lfaW9hcGljKHUzMiBnc2kpCiB7CiAj
aWZkZWYgQ09ORklHX1g4Nl9JT19BUElDCisJLyogc2hvdWxkIG5vdCB3b3JyeSBhYm91dCBzaHV0
ZG93biBwYXRoICovCisJaWYgKHN5c3RlbV9zdGF0ZSA9PSBTWVNURU1fSEFMVCB8fAorCSAgICBz
eXN0ZW1fc3RhdGUgPT0gU1lTVEVNX1BPV0VSX09GRiB8fAorCSAgICBzeXN0ZW1fc3RhdGUgPT0g
U1lTVEVNX1JFU1RBUlQpCisJCXJldHVybjsKKwogCW1wX3VucmVnaXN0ZXJfZ3NpKGdzaSk7CiAj
ZW5kaWYKIH0K
--089e0129478405ac1404fcc90532--
