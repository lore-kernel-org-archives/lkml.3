Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952AbaJFTo0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 15:44:26 -0400
Received: from static.92.5.9.176.clients.your-server.de ([176.9.5.92]:49324
	"EHLO mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbaJFToZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 15:44:25 -0400
Date: Mon, 6 Oct 2014 21:44:23 +0200
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Andrey Wagin <avagin@gmail.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: BUG at /build/buildd/linux-3.13.0/fs/pnode.c:372!
Message-ID: <20141006194423.GA31207@mail.hallyn.com>
References: <CANaxB-zcCrJ5K5O8Wz4+h9XEE5BdV52N9mqWFQEpG_kECVJyvw@mail.gmail.com>
 <20141006181911.GA30242@mail.hallyn.com>
 <CANaxB-x+GUuKKimUjBGqSzg2yZEE1tso=nZaevXVQXMKdy2hvQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANaxB-x+GUuKKimUjBGqSzg2yZEE1tso=nZaevXVQXMKdy2hvQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andrey Wagin (avagin@gmail.com):
> 2014-10-06 22:19 GMT+04:00 Serge E. Hallyn <serge@hallyn.com>:
> > Quoting Andrey Wagin (avagin@gmail.com):
> >> Hi All,
> >>
> >> Here is a small program, which triggers a bug. Is it interested for someone?
> >
> > Yup, would
> >
> > diff --git a/fs/namespace.c b/fs/namespace.c
> > index ef42d9b..ddef25d 100644
> > --- a/fs/namespace.c
> > +++ b/fs/namespace.c
> > @@ -3046,6 +3046,9 @@ static int mntns_install(struct nsproxy *nsproxy, void *ns)
> >         struct mnt_namespace *mnt_ns = ns;
> >         struct path root;
> >
> > +       if (mnt_ns == nsproxy->mnt_ns)
> > +               return 0;
> > +
> >         if (!ns_capable(mnt_ns->user_ns, CAP_SYS_ADMIN) ||
> >             !ns_capable(current_user_ns(), CAP_SYS_CHROOT) ||
> >             !ns_capable(current_user_ns(), CAP_SYS_ADMIN))
> >
> > fix it?
> 
> Actually the bug is triggered from the second umount. I think we need

Oh, I see.

> something like this:
> diff --git a/fs/namespace.c b/fs/namespace.c
> index 68685b2..bbcd92c 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
> @@ -1363,6 +1363,9 @@ static int do_umount(struct mount *mnt, int flags)
>                 return retval;
>         }
> 
> +       if (mnt->mnt_parent == mnt)

looks good (or the equivalent  mnt_has_parent(mnt)).  Have you tested that
this prevents your test program from causing a crash?

> +               return -EINVAL;
> +
>         namespace_lock();
>         lock_mount_hash();
>         event++;
> 
> root@ubuntu:/home/avagin# strace ./a.out
> ...
> open("/proc/self/ns/mnt", O_RDONLY)     = 3
> umount("/", MNT_DETACH)                 = 0
> setns(3, 131072)                        = 0
> umount("/", MNT_DETACH)                 = -1 EINVAL (Invalid argument)
> exit_group(0)                           = ?
> +++ exited with 0 +++
> 
> >
> >> root@ubuntu:/home/avagin# cat nsenter.c
> >> #define _GNU_SOURCE             /* See feature_test_macros(7) */
> >> #include <sched.h>
> >> #include <sys/types.h>
> >> #include <sys/stat.h>
> >> #include <fcntl.h>
> >> #include <unistd.h>
> >> #include <sys/mount.h>
> >>
> >> int main(int argc, char **argv)
> >> {
> >>         int fd;
> >>
> >>         fd = open("/proc/self/ns/mnt", O_RDONLY);
> >>         if (fd < 0)
> >>                 return 1;
> >>         umount2("/", MNT_DETACH);
> >>         if (setns(fd, CLONE_NEWNS))
> >>                 return 1;
> >>         umount2("/", MNT_DETACH);
> >>
> >>         return 0;
> >> }
> >>
> >> root@ubuntu:/home/avagin# gcc nsenter.c -o nsenter
> >> root@ubuntu:/home/avagin# ./nsenter
> >>
> >>
> >> [  260.548301] ------------[ cut here ]------------
> >> [  260.550941] kernel BUG at /build/buildd/linux-3.13.0/fs/pnode.c:372!
> >> [  260.552068] invalid opcode: 0000 [#1] SMP
> >> [  260.552068] Modules linked in: xt_CHECKSUM iptable_mangle xt_tcpudp
> >> xt_addrtype xt_conntrack ipt_MASQUERADE iptable_nat nf_conntrack_ipv4
> >> nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack bridge stp llc
> >> dm_thin_pool dm_persistent_data dm_bufio dm_bio_prison iptable_filter
> >> ip_tables x_tables crct10dif_pclmul crc32_pclmul ghash_clmulni_intel
> >> binfmt_misc nfsd auth_rpcgss nfs_acl aesni_intel nfs lockd aes_x86_64
> >> sunrpc fscache lrw gf128mul glue_helper ablk_helper cryptd serio_raw
> >> ppdev parport_pc lp parport btrfs xor raid6_pq libcrc32c psmouse
> >> floppy
> >> [  260.552068] CPU: 0 PID: 1723 Comm: nsenter Not tainted
> >> 3.13.0-30-generic #55-Ubuntu
> >> [  260.552068] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> >> [  260.552068] task: ffff8800376097f0 ti: ffff880074824000 task.ti:
> >> ffff880074824000
> >> [  260.552068] RIP: 0010:[<ffffffff811e9483>]  [<ffffffff811e9483>]
> >> propagate_umount+0x123/0x130
> >> [  260.552068] RSP: 0018:ffff880074825e98  EFLAGS: 00010246
> >> [  260.552068] RAX: ffff88007c741140 RBX: 0000000000000002 RCX: ffff88007c741190
> >> [  260.552068] RDX: ffff88007c741190 RSI: ffff880074825ec0 RDI: ffff880074825ec0
> >> [  260.552068] RBP: ffff880074825eb0 R08: 00000000000172e0 R09: ffff88007fc172e0
> >> [  260.552068] R10: ffffffff811cc642 R11: ffffea0001d59000 R12: ffff88007c741140
> >> [  260.552068] R13: ffff88007c741140 R14: ffff88007c741140 R15: 0000000000000000
> >> [  260.552068] FS:  00007fd5c7e41740(0000) GS:ffff88007fc00000(0000)
> >> knlGS:0000000000000000
> >> [  260.552068] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >> [  260.552068] CR2: 00007fd5c7968050 CR3: 0000000070124000 CR4: 00000000000406f0
> >> [  260.552068] Stack:
> >> [  260.552068]  0000000000000002 0000000000000002 ffff88007c631000
> >> ffff880074825ed8
> >> [  260.552068]  ffffffff811dcfac ffff88007c741140 0000000000000002
> >> ffff88007c741160
> >> [  260.552068]  ffff880074825f38 ffffffff811dd12b ffffffff811cc642
> >> 0000000075640000
> >> [  260.552068] Call Trace:
> >> [  260.552068]  [<ffffffff811dcfac>] umount_tree+0x20c/0x260
> >> [  260.552068]  [<ffffffff811dd12b>] do_umount+0x12b/0x300
> >> [  260.552068]  [<ffffffff811cc642>] ? final_putname+0x22/0x50
> >> [  260.552068]  [<ffffffff811cc849>] ? putname+0x29/0x40
> >> [  260.552068]  [<ffffffff811dd88c>] SyS_umount+0xdc/0x100
> >> [  260.552068]  [<ffffffff8172aeff>] tracesys+0xe1/0xe6
> >> [  260.552068] Code: 89 50 08 48 8b 50 08 48 89 02 49 89 45 08 e9 72
> >> ff ff ff 0f 1f 44 00 00 4c 89 e6 4c 89 e7 e8 f5 f6 ff ff 48 89 c3 e9
> >> 39 ff ff ff <0f> 0b 66 2e 0f 1f 84 00 00 00 00 00 90 66 66 66 66 90 55
> >> b8 01
> >> [  260.552068] RIP  [<ffffffff811e9483>] propagate_umount+0x123/0x130
> >> [  260.552068]  RSP <ffff880074825e98>
> >> [  260.611451] ---[ end trace 11c33d85f1d4c652 ]---
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> Please read the FAQ at  http://www.tux.org/lkml/
