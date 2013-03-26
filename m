Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759636Ab3CZHbH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 03:31:07 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:63961 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759621Ab3CZHbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 03:31:05 -0400
Message-ID: <51514EA9.8080801@huawei.com>
Date: Tue, 26 Mar 2013 15:30:49 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Ming Lei <ming.lei@canonical.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH 1/2] sysfs: fix race between readdir and lseek
References: <1363793126-11510-1-git-send-email-ming.lei@canonical.com> <1363793126-11510-2-git-send-email-ming.lei@canonical.com> <514A7340.5040409@huawei.com> <CACVXFVN7urpLM+Q-3o9=hYQLM=544WTXh+BnSo9fBM+d07oapQ@mail.gmail.com> <514A7E72.2090200@huawei.com> <CACVXFVMS644BpX7voMHS-xXoRs9-G4y96=ubk_NAj6KDTy1ENQ@mail.gmail.com> <514BF0BE.1070907@huawei.com> <CACVXFVOAFqVoNP-igJ-WeaJ+rKF-gREcHqspHWOkz4EJ9Gn94w@mail.gmail.com>
In-Reply-To: <CACVXFVOAFqVoNP-igJ-WeaJ+rKF-gREcHqspHWOkz4EJ9Gn94w@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/3/22 17:31, Ming Lei wrote:
> On Fri, Mar 22, 2013 at 1:48 PM, Li Zefan <lizefan@huawei.com> wrote:
>> On 2013/3/21 12:48, Ming Lei wrote:
>>
>> Yes, it can...As I said, it's irrelevant, because it's vfs that changes
>> file->f_pos.
>>
>> SYSCALL_DEFINE3(read, unsigned int, fd, char __user *, buf, size_t, count)
>> {
>>         struct fd f = fdget(fd);
>>         ssize_t ret = -EBADF;
>>
>>         if (f.file) {
>>                 loff_t pos = file_pos_read(f.file);             <--- read f_pos
>>                 ret = vfs_read(f.file, buf, count, &pos);       <--- return -EISDIR
>>                 file_pos_write(f.file, pos);                    <--- write f_pos
> 
> Considered that f_pos of sysfs directory is always less than INT_MAX,
> we need't worry about atomic writing it in file_pos_write().
> 
> The only probable problem on sysfs is below scenario in read()/write():
> 
> -  pos is read as less than 2 in file_pos_read(f.file)
> -  ret = vfs_read(f.file, buf, count, &pos)
>           ---> readdir() in another path
> -  file_pos_write(pos)
>          ---> readdir() found f_pos becomes 0 or 1, and may cause
> use-after-free problem
> 
> Considered that vfs_read()/vfs_write on sysfs dir is almost doing nothing, the
> above problem may only exist in theory.

The read() vs readdir() race in sysfs directory doesn't exist in theory only.

Mar 25 11:16:57 lxc34 kernel: [ 3581.923110] ------------[ cut here ]------------
Mar 25 11:16:57 lxc34 kernel: [ 3581.923124] WARNING: at fs/sysfs/sysfs.h:195 sysfs_readdir+0x277/0x290()
Mar 25 11:16:57 lxc34 kernel: [ 3581.923131] Hardware name: Tecal RH2285
Mar 25 11:16:57 lxc34 kernel: [ 3581.923136] Modules linked in: iscsi_tcp libiscsi_tcp libiscsi scsi_transport_i
scsi bridge ipv6 stp llc cpufreq_conservative cpufreq_userspace cpufreq_powersave binfmt_misc fuse loop dm_mod c
oretemp acpi_cpufreq mperf crc32c_intel ghash_clmulni_intel aesni_intel ablk_helper cryptd lrw aes_x86_64 xts gf
128mul bnx2 iTCO_wdt iTCO_vendor_support sg i2c_i801 ehci_pci mptctl tpm_tis tpm tpm_bios serio_raw microcode lp
c_ich i2c_core hid_generic mfd_core button usbhid hid uhci_hcd ehci_hcd usbcore usb_common sd_mod crc_t10dif edd
 ext3 mbcache jbd fan processor ide_pci_generic ide_core ata_generic ata_piix libata mptsas mptscsih mptbase scs
i_transport_sas scsi_mod thermal thermal_sys hwmon
Mar 25 11:16:57 lxc34 kernel: [ 3581.923238] Pid: 13289, comm: a.out Not tainted 3.9.0-rc1-0.7-default+ #38
Mar 25 11:16:57 lxc34 kernel: [ 3581.923245] Call Trace:
Mar 25 11:16:57 lxc34 kernel: [ 3581.923251]  [<ffffffff8120b137>] ? sysfs_readdir+0x277/0x290
Mar 25 11:16:57 lxc34 kernel: [ 3581.923258]  [<ffffffff8120b137>] ? sysfs_readdir+0x277/0x290
Mar 25 11:16:57 lxc34 kernel: [ 3581.923273]  [<ffffffff81042d3f>] warn_slowpath_common+0x7f/0xc0
Mar 25 11:16:57 lxc34 kernel: [ 3581.923281]  [<ffffffff81042d9a>] warn_slowpath_null+0x1a/0x20
Mar 25 11:16:57 lxc34 kernel: [ 3581.923288]  [<ffffffff8120b137>] sysfs_readdir+0x277/0x290
Mar 25 11:16:57 lxc34 kernel: [ 3581.923296]  [<ffffffff811a11a0>] ? sys_ioctl+0x90/0x90
Mar 25 11:16:57 lxc34 kernel: [ 3581.923303]  [<ffffffff811a11a0>] ? sys_ioctl+0x90/0x90
Mar 25 11:16:57 lxc34 kernel: [ 3581.923310]  [<ffffffff811a1589>] vfs_readdir+0xa9/0xc0
Mar 25 11:16:57 lxc34 kernel: [ 3581.923317]  [<ffffffff811a163b>] sys_getdents64+0x9b/0x110
Mar 25 11:16:57 lxc34 kernel: [ 3581.923327]  [<ffffffff814bb5d9>] system_call_fastpath+0x16/0x1b
Mar 25 11:16:57 lxc34 kernel: [ 3581.923333] ---[ end trace a995ae360b2301bd ]---
Mar 25 11:16:57 lxc34 kernel: [ 3581.923339] ida_remove called for id=19055 which is not allocated.
...

And finally my kernel crashed.

I'm not asking you to fix it, but just let you know about this bug. Al proposed a fix but I don't know
if he'll work on it.

