Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933604Ab3CGWTV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 17:19:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56966 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932792Ab3CGWTS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 17:19:18 -0500
Date: Thu, 7 Mar 2013 17:18:00 -0500
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: BUG_ON(nd->inode->i_op->follow_link);
Message-ID: <20130307221800.GA572@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>
References: <20130307021645.GA10173@redhat.com>
 <20130307153052.GA18246@redhat.com>
 <CA+55aFyVZeDswi=M65ULQkGCvJq5vsASLqGCtufH3TcS--MC1Q@mail.gmail.com>
 <20130307193501.GA2802@redhat.com>
 <CA+55aFwDYocNRjSCJk1PYw0MFy7dpKf1yMMEiePP--=ewQcX6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwDYocNRjSCJk1PYw0MFy7dpKf1yMMEiePP--=ewQcX6A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 07, 2013 at 12:33:46PM -0800, Linus Torvalds wrote:

 > If this is fairly repeatable, I really think it would be interesting
 > to see the names involved. Especially for sysfs, there are a *lot* of
 > random files that have odd semantics, and it depends on the file. Same
 > is (to a slightly lesser degree) true of /proc (which does have many
 > of the same issues, but tends to be more tested just for having been
 > around for longer - but then proc does have some issues all its own)
 > 
 > So for example, if you can re-create the one in nd_jump_link(), it
 > would be lovely if you replaced the BUG_ON() with just an if(), and
 > made it print out the old and the new path dentry names (ok, that
 > means saving the old path and doing the path_put on it afterwards).
 > 
 > Something like
 > 
 > +    const char *oldname = nd->path.dentry->d_name.name;   /* Yeah,
 > this remembers the name pointer over the put_path(), not strictly
 > right */
 > +    const char *newname = path->dentry->d_name.name;
 >       ...
 > -    BUG_ON(nd->inode->i_op->follow_link);
 > +    if (WARN_ON(nd->inode->i_op->follow_link)) {
 > +        printk("old=%s new=%d\n", oldname, newname);
 > +    }
 
Ok, that didn't enlightenment me so much..

[  304.559707] WARNING: at fs/namei.c:696 nd_jump_link+0x85/0xa0()
[  304.570426] Hardware name: GA-MA78GM-S2H
[  304.571037] Modules linked in: fuse l2tp_ppp l2tp_core rfcomm can_raw scsi_transport_iscsi ipt_ULOG af_key netrom pppoe pppox ppp_generic slhc rose caif_socket ax25 caif can_bcm ipx llc2 p8023 appletalk irda af_rxrpc phonet psnap p8022 rds can llc nfc crc_ccitt x25 nfnetlink decnet atm lockd sunrpc ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_conntrack nf_conntrack ip6table_filter ip6_tables snd_hda_codec_realtek btusb snd_hda_intel snd_hda_codec bluetooth vhost_net snd_pcm tun macvtap microcode macvlan snd_page_alloc usb_debug r8169 edac_core rfkill serio_raw kvm_amd snd_timer pcspkr kvm mii snd soundcore
[  304.642098] Pid: 14550, comm: trinity-child1 Not tainted 3.9.0-rc1+ #71
[  304.690489] Call Trace:
[  304.690888]  [<ffffffff810440e5>] warn_slowpath_common+0x75/0xa0
[  304.691849]  [<ffffffff8104412a>] warn_slowpath_null+0x1a/0x20
[  304.692736]  [<ffffffff811c1795>] nd_jump_link+0x85/0xa0
[  304.693541]  [<ffffffff81224aec>] proc_pid_follow_link+0x6c/0x70
[  304.694445]  [<ffffffff811be661>] path_lookupat+0x2d1/0x740
[  304.695270]  [<ffffffff811beb04>] filename_lookup+0x34/0xc0
[  304.696112]  [<ffffffff811c193e>] user_path_at_empty+0x8e/0x110
[  304.697007]  [<ffffffff811c19d1>] user_path_at+0x11/0x20
[  304.697800]  [<ffffffff811d944f>] sys_setxattr+0x3f/0xe0
[  304.698609]  [<ffffffff816cdbc2>] system_call_fastpath+0x16/0x1b
[  304.722423] ---[ end trace 469ba8f58f5994e6 ]---
[  304.723132] old=fd new=1:9


thoughts ?

	Dave
