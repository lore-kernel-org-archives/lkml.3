Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758811AbaDVVbP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 17:31:15 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:57259 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435AbaDVVbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 17:31:11 -0400
MIME-Version: 1.0
In-Reply-To: <20140422185802.GA31201@amd.pavel.ucw.cz>
References: <cover.1398097304.git.luto@amacapital.net>
	<430cfc67aae9b9ad5eab4d293107285ad44c5fd9.1398097304.git.luto@amacapital.net>
	<CANq1E4T1P-g+wA6bZQe6=79-+QLmXReu4namcPifw-SZViqW-Q@mail.gmail.com>
	<20140422143152.GA23716@amd.pavel.ucw.cz>
	<CANq1E4TPPcdD-8FF_Kc=r44Vrd51Vmt-OVu+EtCC-oEzXkvJvg@mail.gmail.com>
	<20140422185802.GA31201@amd.pavel.ucw.cz>
Date: Tue, 22 Apr 2014 23:31:11 +0200
Message-ID: <CANq1E4R4PSuDD599n=0Xff+rfH01CTRtzLSkFDWSdnXMggVKRA@mail.gmail.com>
Subject: Re: [RFC 2/2] fs,proc: Respect FMODE_WRITE when opening /proc/pid/fd/N
From: David Herrmann <dh.herrmann@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Andy Lutomirski <luto@amacapital.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Theodore Ts'o" <tytso@mit.edu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Tue, Apr 22, 2014 at 8:58 PM, Pavel Machek <pavel@ucw.cz> wrote:
> I don't think openat helps you. This is what we are talking about, it
> is easy to reproduce. Can you reproduce it without /proc mounted?
>
> I think that chmod 700 . should stop you. Openat seems no worse than
> just placing cwd there...

Example1:
$ mkdir -p subdir/next
$ chmod 000 subdir
$ touch subdir/next/test
=> EACCES
$ cd subdir
=> EACCES

Example2:
$ mkdir -p subdir/next
$ cd subdir/next
$ chmod 000 ..
$ touch test
=> SUCCESS

This is the exact same situation. The filesystem tree is exactly the
same in both situations, but in the first example CWD is outside of
"subdir", in the second example CWD is inside of "subdir". Thus, they
can create files in that directory, even though they have no access to
_any_ absolute path to that directory.

This is the exact same race that you describe via /proc/self/fd/. But
instead of keeping a ref to the dir via CWD, in your example you keep
the ref via a FD in that exact same directory and access it via /proc.

(Hint: instead of using CWD, you can also keep an FD via open(O_PATH)
and pass it to openat())

Thanks
David
