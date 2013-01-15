Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757495Ab3AOBEa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 20:04:30 -0500
Received: from mail-bk0-f54.google.com ([209.85.214.54]:63982 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757464Ab3AOBE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 20:04:27 -0500
MIME-Version: 1.0
In-Reply-To: <20130114231110.GA30943@liondog.tnic>
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
	<1357260531-11115-23-git-send-email-yinghai@kernel.org>
	<20130113214132.GB17200@liondog.tnic>
	<CAE9FiQVQRAOtw7kiPJO3xszJx9uPFjgK82PjbvTyqzJgujdicw@mail.gmail.com>
	<50F4452D.2060000@zytor.com>
	<CAE9FiQXkgoLKp3ZnOcM9gLDJNGNxUE8WSRXiQy1G_v5Os5_v2A@mail.gmail.com>
	<20130114200505.GC2015@liondog.tnic>
	<CAE9FiQWXxmOnoc1wJzHUYCyO8hHvLOkNpGMwM8vVubjMAGJ5dA@mail.gmail.com>
	<20130114202623.GD2015@liondog.tnic>
	<CAE9FiQUPXa43AfcC13VCkR8AJ7PauMqmfNed9V9Q5zoLLuqJKw@mail.gmail.com>
	<20130114231110.GA30943@liondog.tnic>
Date: Mon, 14 Jan 2013 17:04:25 -0800
X-Google-Sender-Auth: 0n-NRoWHtyx60afeKgh4hoXM3oU
Message-ID: <CAE9FiQU4mSzpLd9yTzMjAZCprC+FHYqn3Fw3xfgQK_Lnr8RtQw@mail.gmail.com>
Subject: Re: [PATCH v7u1 22/31] x86, boot: add fields to support load bzImage
 and ramdisk above 4G
From: Yinghai Lu <yinghai@kernel.org>
To: Borislav Petkov <bp@alien8.de>, Yinghai Lu <yinghai@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>,
        Matt Fleming <matt.fleming@intel.com>,
        Gokul Caushik <caushik1@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Joe Millenbach <jmillenbach@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2013 at 3:11 PM, Borislav Petkov <bp@alien8.de> wrote:
>> >> +       /*
>> >> +        * kernel have sentinel to set as 0xff in setup link scripts,
>> >> +        * so if bootloader just copy whole page from kernel image to
>> >> +        * get setup_header instead of clearing boot_param buffer and
>> >> +        * copying setup_header only, will leave sentinel as 0xff.
>> >> +        * With that, we can tell some fields in boot_param have
>> >> +        * invalid values, and we need to zero them in kernel.
>
> Ok, but this needlessly mentiones some sort of allocation technique
> which the bootloader does and which we don't care about. What we do care
> about is the sentinel variable and what it means: if the bootloader
> copies it accidentally, we use *that* as a trigger. So let's revise it:
>
> "The sentinel variable is set by the linker script to 0xff. A bootloader
> is supposed to only take setup_header and put it into a clean
> boot_params buffer. If it turns out that it is clumsy or too generous
> with the buffer, it most probably will pick up the sentinel variable
> too. The fact that this variable then is still non-zero signals to
> us that that we should zero out certain portions of boot_params (see
> sanitize_real_mode()) because we assume that they contain garbage."


ok, I changed to :

        /*
         * The sentinel is set to 0xff via the linker script (setup.ld).
         * A bootloader is supposed to only take setup_header and put
         * it into a clean boot_params buffer. If it turns out that
         * it is clumsy or too generous with the buffer, it most
         * probably will pick up the sentinel variable too. The fact
         * that this variable then is still 0xff will let kernel
         * know that some variables in boot_params are invalid and
         * kernel should zero out certain portions of boot_params
         * (see sanitize_real_mode()).
         */
