Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538Ab3GPGm6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 02:42:58 -0400
Received: from mail-vb0-f41.google.com ([209.85.212.41]:54715 "EHLO
	mail-vb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091Ab3GPGm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 02:42:56 -0400
MIME-Version: 1.0
In-Reply-To: <87ppujysbk.fsf@rustcorp.com.au>
References: <20130715182010.GA4853@pmhahn.de> <87ppujysbk.fsf@rustcorp.com.au>
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Date: Tue, 16 Jul 2013 03:42:35 -0300
Message-ID: <CAMOw1v7AHC3=dFh8vQWTf7dhu1zMbbPwNtJXAtnoqR48YWjtcQ@mail.gmail.com>
Subject: Re: [BUG] 3.10.[01] modprobe snd-... hangs
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Philipp Matthias Hahn <pmhahn@pmhahn.de>, alsa-devel@alsa-project.org,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-modules <linux-modules@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 2:41 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> Philipp Matthias Hahn <pmhahn@pmhahn.de> writes:
>> Hello,
>>
>> My x86_64 systems has some trouble loading some ALSA snd-* modules since
>> the upgrade to 3.10.[01]: Several automatic modprobe calls hang, but
>> loading snd-intel-hda and snd-audio-usb by hand still works.
>
> Not a known problem to me, at least.  Perhaps it's a dep loop somehow.

First thing to check is the /etc/modprobe.d/*.conf file that contains
these install commands. Did they change besides the kernel upgrade?

[
   Not really related to this, but... people/distros should stop using
install commands for things like this. By using softdeps kmod is smart
enough to detect and (possibly) break loops. With  install commands it
can't because it has no idea what the install command will do.
]

>
>> ...
>>  1071 ?        S      0:00 sh -c /sbin/modprobe --ignore-install snd && { /sbin/modprobe --quiet snd
>>  1080 ?        D      0:00  \_ /sbin/modprobe --quiet snd-seq
>
> This was first, and it's waiting.  Which means it must be doing
> something weird, because snd_seq_oss is loading now:
>
>> snd_seq_oss 33717 1 - Loading 0xffffffffa041b000

Searching kmod's log, I guess Debian still has:

 install snd_seq modprobe --ignore-install snd-seq $CMDLINE_OPTS && {
modprobe --quiet snd-seq-midi ; modprobe --quiet snd-seq-oss ; : ; }

>
> Perhaps in the tangle of modprobe install commands somewhere this gets
> invoked?
>
>> # ps axf
>>   460 ?        S      0:00  \_ [kworker/u8:3]
>>  1087 ?        S      0:00  |   \_ [kworker/u8:3]
>>  1092 ?        S      0:00  |       \_ /sbin/modprobe -q -- snd-seq-client-14

Weird... this is coming from a request_module(). Greping... this
should only be coming from

git grep request_module | grep snd-seq-client
sound/core/seq/seq_clientmgr.c: request_module("snd-seq-client-%i",

Philipp, which kernel are you upgrading from?  I don't see anything to
blame in the changes for the past releases. Any chance a bad entry in
your .conf was added too? You may want to paste the output of modprobe
-c, at least until "# End of configuration files. Dumping indexes
now:"

>
> On my systems, that's snd-seq-dummy, which depends on snd_seq.  Which,
> in fact, is already loaded.
>
> Lucas, any clues?

I don't think I could help, but we need more data, like the ones above.


Lucas De Marchi
