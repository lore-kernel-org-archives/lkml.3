Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874AbaDVWMR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 18:12:17 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33479 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754902AbaDVWMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 18:12:14 -0400
Date: Wed, 23 Apr 2014 00:12:13 +0200
From: Pavel Machek <pavel@ucw.cz>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [RFC 2/2] fs,proc: Respect FMODE_WRITE when opening
 /proc/pid/fd/N
Message-ID: <20140422221213.GB32754@amd.pavel.ucw.cz>
References: <cover.1398097304.git.luto@amacapital.net>
 <430cfc67aae9b9ad5eab4d293107285ad44c5fd9.1398097304.git.luto@amacapital.net>
 <CANq1E4T1P-g+wA6bZQe6=79-+QLmXReu4namcPifw-SZViqW-Q@mail.gmail.com>
 <20140422143152.GA23716@amd.pavel.ucw.cz>
 <CANq1E4TPPcdD-8FF_Kc=r44Vrd51Vmt-OVu+EtCC-oEzXkvJvg@mail.gmail.com>
 <20140422185802.GA31201@amd.pavel.ucw.cz>
 <CANq1E4R4PSuDD599n=0Xff+rfH01CTRtzLSkFDWSdnXMggVKRA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANq1E4R4PSuDD599n=0Xff+rfH01CTRtzLSkFDWSdnXMggVKRA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2014-04-22 23:31:11, David Herrmann wrote:
> Hi
> 
> On Tue, Apr 22, 2014 at 8:58 PM, Pavel Machek <pavel@ucw.cz> wrote:
> > I don't think openat helps you. This is what we are talking about, it
> > is easy to reproduce. Can you reproduce it without /proc mounted?
> >
> > I think that chmod 700 . should stop you. Openat seems no worse than
> > just placing cwd there...
> 
> Example1:
> $ mkdir -p subdir/next
> $ chmod 000 subdir
> $ touch subdir/next/test
> => EACCES
> $ cd subdir
> => EACCES
> 
> Example2:
> $ mkdir -p subdir/next
> $ cd subdir/next
> $ chmod 000 ..
> $ touch test
> => SUCCESS
> 
> This is the exact same situation. The filesystem tree is exactly the
> same in both situations, but in the first example CWD is outside of
> "subdir", in the second example CWD is inside of "subdir". Thus, they
> can create files in that directory, even though they have no access to
> _any_ absolute path to that directory.
> 
> This is the exact same race that you describe via /proc/self/fd/. But
> instead of keeping a ref to the dir via CWD, in your example you keep
> the ref via a FD in that exact same directory and access it via
> /proc.

Yes, that's how permissions work. You snipped my example. Can you show
how to write to "unwritable_file" below without /proc? Because I
believe I got my chmods right.

pavel@toy:/tmp$ uname -a
Linux toy.ucw.cz 2.6.32-rc3 #21 Mon Oct 19 07:32:02 CEST 2009 armv5tel
GNU/Linux
pavel@toy:/tmp mkdir my_priv; cd my_priv
pavel@toy:/tmp/my_priv$ echo this file should never be writable >
unwritable_file
# lock down directory
pavel@toy:/tmp/my_priv$ chmod 700 .
# relax file permissions, directory is private, so this is safe
# check link count on unwritable_file. We would not want someone
# to have a hard link to work around our permissions, would we?
pavel@toy:/tmp/my_priv$ chmod 666 unwritable_file
pavel@toy:/tmp/my_priv$ cat unwritable_file
this file should never be writable
pavel@toy:/tmp/my_priv$ cat unwritable_file
got you
# Security problem here


> (Hint: instead of using CWD, you can also keep an FD via open(O_PATH)
> and pass it to openat())

Feel free to use openat(), too.

Thanks,
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
