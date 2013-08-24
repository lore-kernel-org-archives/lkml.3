Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901Ab3HXVYo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Aug 2013 17:24:44 -0400
Received: from 1wt.eu ([62.212.114.60]:35581 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755691Ab3HXVYn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Aug 2013 17:24:43 -0400
Date: Sat, 24 Aug 2013 23:24:32 +0200
From: Willy Tarreau <w@1wt.eu>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "security@kernel.org" <security@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Brad Spengler <spender@grsecurity.net>
Subject: Re: /proc/pid/fd && anon_inode_fops
Message-ID: <20130824212432.GA9299@1wt.eu>
References: <b121a1082bf3365fda22a131782147c169c969f5.1377112282.git.luto@amacapital.net> <CA+55aFzXNU-eJ7KeZyv5YYKKtm8iorG-o3QtD7NXx0GTzuH+Bw@mail.gmail.com> <20130822185317.GI31117@1wt.eu> <CALCETrWYeNXhEDY7S9XLD6L0wOZu8iPVO6LN3A_797hLHfBzAw@mail.gmail.com> <CA+55aFw3AM2Xe2aNUKk0x8ZrZHbY4QnaRZbZdAqf1trT+dGDmQ@mail.gmail.com> <CALCETrU2xBykonV2N8bSysdycfZkCq_P5bUnrN5SjZo2_5dNrg@mail.gmail.com> <20130822201530.GL31117@1wt.eu> <20130824182939.GA23630@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130824182939.GA23630@redhat.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oleg,

On Sat, Aug 24, 2013 at 08:29:39PM +0200, Oleg Nesterov wrote:
> Sorry for off-topic, I am just curios.
> 
> On 08/22, Willy Tarreau wrote:
> >
> > It's not only that, it also supports sockets and pipes that you can access
> > via /proc/pid/fd and not via a real symlink which would try to open eg
> > "pipe:[23456]" instead of the real file.
> 
> But sock_no_open() disallows this, and for good reason I guess.

Hmmm not exactly, it works for a pipe but not for a socket. It even
breaks /dev/stdin (/proc/self/fd/0) for processes running attached
to a socket (eg: shell script) :

sh-3.1$ ls -la /proc/$$/fd/
total 0
dr-x------ 2 willy users  0 Aug 24 23:03 .
dr-xr-xr-x 6 willy users  0 Aug 24 23:03 ..
lrwx------ 1 willy users 64 Aug 24 23:03 0 -> socket:[1247293]
lrwx------ 1 willy users 64 Aug 24 23:03 1 -> socket:[1247293]
lrwx------ 1 willy users 64 Aug 24 23:03 2 -> socket:[1247293]
lrwx------ 1 willy users 64 Aug 24 23:03 255 -> socket:[1247293]
sh-3.1$ read < /dev/stdin
sh: /dev/stdin: No such device or address
sh-3.1$ read < /dev/fd/0
sh: /dev/fd/0: No such device or address

But :

window 1:
  willy@pcw:~$ ssh 0 sh -i
  sh-3.1$ echo $$
  9832
  sh-3.1$ ls -la /proc/$$/fd/
  total 0
  dr-x------ 2 willy users  0 Aug 24 23:16 .
  dr-xr-xr-x 6 willy users  0 Aug 24 23:16 ..
  lr-x------ 1 willy users 64 Aug 24 23:16 0 -> pipe:[1247914]
  l-wx------ 1 willy users 64 Aug 24 23:16 1 -> pipe:[1247915]
  l-wx------ 1 willy users 64 Aug 24 23:16 2 -> pipe:[1247916]
  l-wx------ 1 willy users 64 Aug 24 23:17 255 -> pipe:[1247916]
  sh-3.1$ 

window 2:
  willy@pcw:~$ echo hello > /proc/9832/fd/1
  willy@pcw:~$ echo whoami > /proc/9832/fd/0

window 1:
  sh-3.1$ hello
  willy
  sh-3.1$ 

> I am wondering, perhaps anon_inode should do the same? I do not
> see any problem, but it looks pointless and misleading to allow
> to open a file you can do nothing with.

I don't know, I'm often a bit confused by entries in /proc/pid/fd
because I don't always know which ones might safely be used or not.

> Or is there any reason why, say, open("anon_inode:[perf_event]")
> should succeed?

I doubt it. It seems to me that most such entries are implemented
for completeness while most valid uses only concern /proc/self/fd.
Maybe if we had an option so that only /proc/self/fd would actually
allow to access the fds while all /proc/pid/fd would only show what
they map to, it would be a good step forward.

> Thanks,
> 
> Oleg.
> 
> --- x/fs/anon_inodes.c
> +++ x/fs/anon_inodes.c
> @@ -24,7 +24,15 @@
>  
>  static struct vfsmount *anon_inode_mnt __read_mostly;
>  static struct inode *anon_inode_inode;
> -static const struct file_operations anon_inode_fops;
> +
> +static int anon_open(struct inode *inode, struct file *file)
> +{
> +	return -ENXIO;
> +}
> +
> +static const struct file_operations anon_inode_fops = {
> +	.open = anon_open,
> +};
>  
>  /*
>   * anon_inodefs_dname() is called from d_path().

regards,
willy

