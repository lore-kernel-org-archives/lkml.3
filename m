Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750AbaEEG7A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 02:59:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59132 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754473AbaEEG66 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 02:58:58 -0400
Date: Mon, 5 May 2014 14:57:39 +0800
From: Baoquan He <bhe@redhat.com>
To: rjw@rjwysocki.net, linux-acpi@vger.kernel.org, linux-ia64@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dyoung@redhat.com
Subject: Re: [Patch v3 1/2] introduce variable acpi_lapic into ia64
Message-ID: <20140505065739.GB1702@dhcp-16-105.nay.redhat.com>
References: <1399265306-8553-1-git-send-email-bhe@redhat.com>
 <20140505051455.GA1702@dhcp-16-105.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140505051455.GA1702@dhcp-16-105.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/14 at 01:14pm, Baoquan He wrote:
> Hi Rafael,
> 
> Thanks for previous comments and suggestions.
> 
> 
> I added the acpi_lapic in ia64. However I didn't find ia64 machine to
> test it. Could you or anyone please help test this 2 patches?
> 
> I don't know how to test UP system running SMP kernel with no LAPIC in
> MADT when it's ia64 arch. 
> 
> Test steps for ia64 kdump:
> 
> 1) get a multi-cpus ia64 machine, build a upstream kernel with SMP and
> ACPI
> 2)install kexec-tools, and edit /etc/sysconfig/kdump to make sure
> "nr_cpus=1" is in KDUMP_COMMANDLINE_APPEND. Then load the kdump kernel
> by below command:
> 
> "kdumpctl restart" or "systemctl restart kdump"

Sorry, here I assume people use fedora distros. The kdump execution
command is like below string which is taken from my fedora automation
script.

/sbin/kexec -p
'--command-line=BOOT_IMAGE=/vmlinuz-3.13.5-202.fc20.x86_64
root=UUID=f170152e-de83-46ee-9546-8ccd53f9753b ro rd.md=0 rd.lvm=0
rd.dm=0 vconsole.keymap=us rd.luks=0 vconsole.font=latarcyrheb-sun16
console=tty0 rd.shell LANG=en_US.UTF-8 console=ttyS0,115200n8
intel_iommu=on irqpoll nr_cpus=1 reset_devices cgroup_disable=memory
mce=off numa=off udev.children-max=2 panic=10 rootflags=nofail
disable_cpu_apicid=0'
--initrd=/boot/initramfs-3.13.5-202.fc20.x86_64kdump.img
/boot/vmlinuz-3.13.5-202.fc20.x86_64

Thanks
Baoquan

> 
> 3) After kdump kernel loaded, execute below shell command. This can make
> crash happen in 2nd cpu.
> 
> taskset -c 1 sh -c "echo c >/proc/sysrq-trigger"
> 
> 
> 4) From console, below error message should not be printed any more. And
> the cpu related to 2nd lapid is present, this can be checked by console
> message and adding debugging code.
> 
> "acpi LNXCPU:0a: BIOS reported wrong ACPI id 0 for the processor."
> 
> --------
> For x86_64, the UP test is taken by adding "disableapic nr_cpus=1" into
> cmdline of grub. The test for kdump is the same as above ia64.
> 
> Thanks
> Baoquan
> 
> 
> On 05/05/14 at 12:48pm, Baoquan He wrote:
> > This variable was defined and assigned in x86, is used to indicate
> > whether LAPIC exists in MADT. Now introduce it into ia64 to help
> > make correct judgment when get information for acpi processor later.
> > 
> > Signed-off-by: Baoquan He <bhe@redhat.com>
> > ---
> >  arch/ia64/include/asm/acpi.h | 1 +
> >  arch/ia64/kernel/acpi.c      | 3 +++
> >  2 files changed, 4 insertions(+)
> > 
> > diff --git a/arch/ia64/include/asm/acpi.h b/arch/ia64/include/asm/acpi.h
> > index d651102..b478219 100644
> > --- a/arch/ia64/include/asm/acpi.h
> > +++ b/arch/ia64/include/asm/acpi.h
> > @@ -85,6 +85,7 @@ ia64_acpi_release_global_lock (unsigned int *lock)
> >  	((Acq) = ia64_acpi_release_global_lock(&facs->global_lock))
> >  
> >  #ifdef	CONFIG_ACPI
> > +extern int acpi_lapic;
> >  #define acpi_disabled 0	/* ACPI always enabled on IA64 */
> >  #define acpi_noirq 0	/* ACPI always enabled on IA64 */
> >  #define acpi_pci_disabled 0 /* ACPI PCI always enabled on IA64 */
> > diff --git a/arch/ia64/kernel/acpi.c b/arch/ia64/kernel/acpi.c
> > index 0d407b3..615ef81 100644
> > --- a/arch/ia64/kernel/acpi.c
> > +++ b/arch/ia64/kernel/acpi.c
> > @@ -56,6 +56,7 @@
> >  
> >  #define PREFIX			"ACPI: "
> >  
> > +int acpi_lapic;
> >  unsigned int acpi_cpei_override;
> >  unsigned int acpi_cpei_phys_cpuid;
> >  
> > @@ -676,6 +677,8 @@ int __init early_acpi_boot_init(void)
> >  	if (ret < 1)
> >  		printk(KERN_ERR PREFIX
> >  		       "Error parsing MADT - no LAPIC entries\n");
> > +	else
> > +		acpi_lapic = 1;
> >  
> >  #ifdef CONFIG_SMP
> >  	if (available_cpus == 0) {
> > -- 
> > 1.8.5.3
> > 
