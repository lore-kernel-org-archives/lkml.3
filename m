Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957Ab3CPSdq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 14:33:46 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:37979 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569Ab3CPSdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 14:33:45 -0400
Message-ID: <5144BB15.3020002@gmail.com>
Date: Sat, 16 Mar 2013 14:33:57 -0400
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130310 Thunderbird/17.0.4
MIME-Version: 1.0
To: Ming Lei <tom.leiming@gmail.com>
CC: Hillf Danton <dhillf@gmail.com>, Dave Jones <davej@redhat.com>,
        Greg Kroah-Hartman <greg@kroah.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: use after free in sysfs_find_dirent
References: <20130307052854.GA23745@redhat.com> <20130307060230.GA31738@kroah.com> <20130307062626.GA25095@redhat.com> <51429D7A.30906@gmail.com> <5142ABD3.4040106@gmail.com> <CAJd=RBAQ9hxY64R7bn_3-jJ2ey8hMGa+Tm2hQVAosgLdRRtd9g@mail.gmail.com> <CACVXFVN5GOa3wLsVgNu2hyymgMtB9aWMPyKzNsAV+9c8=fxM7A@mail.gmail.com> <51448AC9.7080105@gmail.com> <CACVXFVNDSRnG4avn7YdMQFXbQ7B_ONo79jmhWVGzjqEWGTMWYg@mail.gmail.com> <CACVXFVNCGBAYLbbpE1sBiXFNkJpRxVzY44y3Vok+GA9C0MKr3w@mail.gmail.com>
In-Reply-To: <CACVXFVNCGBAYLbbpE1sBiXFNkJpRxVzY44y3Vok+GA9C0MKr3w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/2013 11:58 AM, Ming Lei wrote:
> On Sat, Mar 16, 2013 at 11:22 PM, Ming Lei <tom.leiming@gmail.com> wrote:
>> On Sat, Mar 16, 2013 at 11:07 PM, Sasha Levin <levinsasha928@gmail.com> wrote:
>>>
>>> Hi Ming,
>>>
>>> With your patch:
>>>
>>>
>>> [ 1525.874312] release_sysfs_dirent sysfs_dirent use after free: ptysb-uevent
>>
>> Sasha, thanks for your test.
>>
>> So is the oops always triggered on this node of 'ptysb-uevent' or the node name
>> is changed every time?
> 
> Also, we may dump stack on the release path with the below patch to see who
> did the ugly free.
> 
> --
> diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
> index 2fbdff6..993671d 100644
> --- a/fs/sysfs/dir.c
> +++ b/fs/sysfs/dir.c
> @@ -281,6 +281,12 @@ void release_sysfs_dirent(struct sysfs_dirent * sd)
>  	 */
>  	parent_sd = sd->s_parent;
> 
> +	if(!(sd->s_flags & SYSFS_FLAG_REMOVED)) {
> +		printk("%s sysfs_dirent use after free: %s-%s\n",
> +			__func__, parent_sd->s_name, sd->s_name);
> +		dump_stack();
> +	}
> +
>  	if (sysfs_type(sd) == SYSFS_KOBJ_LINK)
>  		sysfs_put(sd->s_symlink.target_sd);
>  	if (sysfs_type(sd) & SYSFS_COPY_NAME)
> @@ -962,6 +968,9 @@ static struct sysfs_dirent *sysfs_dir_pos(const void *ns,
>  		int valid = !(pos->s_flags & SYSFS_FLAG_REMOVED) &&
>  			pos->s_parent == parent_sd &&
>  			hash == pos->s_hash;
> +		if (valid && (atomic_read(&pos->s_count) <= 1))
> +			printk("%s sysfs_dirent use after free: %s-%s\n",
> +				__func__, parent_sd->s_name, pos->s_name);
>  		sysfs_put(pos);
>  		if (!valid)
>  			pos = NULL;
> 

I don't think it shows what we want it to show thought:

[  327.416905] Pid: 10504, comm: trinity-child98 Tainted: G        W    3.9.0-rc2-next-20130315-sasha-00046-gecde602-dirty #301
[  327.418815] Call Trace:
[  327.419255]  [<ffffffff812f880e>] release_sysfs_dirent+0x4e/0x120
[  327.420595]  [<ffffffff812f89d2>] sysfs_dir_pos+0x92/0x130
[  327.421608]  [<ffffffff812f8b8d>] sysfs_readdir+0x11d/0x280
[  327.422562]  [<ffffffff8128b070>] ? SyS_ioctl+0xa0/0xa0
[  327.423441]  [<ffffffff8128b070>] ? SyS_ioctl+0xa0/0xa0
[  327.424314]  [<ffffffff8128b3e8>] vfs_readdir+0x78/0xc0
[  327.425263]  [<ffffffff8128b54c>] SyS_getdents+0x8c/0x110
[  327.426173]  [<ffffffff83d919d8>] tracesys+0xe1/0xe6

