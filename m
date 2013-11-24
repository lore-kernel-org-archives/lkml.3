Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605Ab3KXJak (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 04:30:40 -0500
Received: from mail-vc0-f182.google.com ([209.85.220.182]:49077 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120Ab3KXJad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 04:30:33 -0500
MIME-Version: 1.0
Date: Sun, 24 Nov 2013 20:30:32 +1100
Message-ID: <CAOcExF-gfjBE7yaRe0A9A71MzSvBSeKeBTVdnyp7_C9d_pYg7g@mail.gmail.com>
Subject: [Slightly OT] Repairing inconsistencies from PDA non-standard FAT32 implementation
From: i336_ <asmqb7@gmail.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there. :)

I've got a bit of a problem I'm hoping you can help me out with. This
isn't exactly kernel-related, although it is Linux-related. I've
posted here since LKML is generally frequented by competant people
with strong and deep understandings of various systems. :) I've sent
this to both linux-kernel and linux-fsdevel.

My Ericsson Mobile Companion MC218 PDA runs Symbian EPOC v1.05, which
does not correctly implement the FAT32 file system.

I have absolutely no idea how I originally found this thread but
http://web.archive.org/web/20030901104427/http://www.opendarwin.org/pipermail/hackers/2002-September/000284.html
was what actually told me what was going on:
  > The issue is that when the Psion's OS (EPOC) creates a new
directory, it doesn't zero out the entire sector, just writes the new
entries followed by one starting with a zero byte (marking the end of
the directory). This means that there's often garbage data after that
zero marker. As far as I can tell, this is `legal', but different from
what Windows does (zeroes out the entire sector first).

As you might be aware, Linux takes the "entire sector zeroed? ok, end
of directory" approach; when it sees a single zero byte Mr. vfat goes
"ooh, anomaly", treats it like a glitch, and keeps reading. So, after
passing a CompactFlash card between Linux and EPOC enough times, it
becomes sufficiently wonky-fied enough that I see stuff like

$ ls
????????.???  () was c.all   even 720.p i    number o.f a      sioninit.ial
?!?"?#??      ) cannot. be   exp and.a d     nverted.to        ssignmen.t
????????.???  /non-roc.ky-   exp() wa.s c    o it on.lin       st() req.uir
[...]
????????.???  ] learn.how    hing, i.go      or is ou.t o      t) a cam.era
????????.???  able or.pro    hstateme.nt     or on th.is       tanceof'. do
[...]
??????.?      argument.s     ion             prototyp.e.m      uments
????????.???  argument.s     ionnoino.pt     prototyp.e.v      ust admi.t,
?<???         aybe i w.ant   ist.se          ps serve.r        w them e.ven
?t??????.?    bject          it seems. to    pt?hiok@.ljq      was not.a f
 `. `         bly disl.ike   itial           put to s.lee      wisexore.xpr
 argumen.ts   bout 900.ms    itiveexp.res    qrcode.php        xpressio.n
[etc...]

Predictable. :P

Thankfully TestDisk works in most situations like these (although it
managed to find 7.1GB of data in a 640MB partition recently) and I can
dump out the filesystem and... start again. Not ideal. :/

The person in the thread linked above was running OS X; Mach's FAT
driver handled the situation okay, but the fsck utility bombed badly.
Fortunately for them, it was easy to reverse the tool's internal rule
prioritization to a configuration which preserved the files. Not so
for me.

The first time this occured I contacted the author of dosfsck, the
utility that one would presumably handle correcting these kinds of
issues, around April 1st 2013. For any of a hundred possible reasons,
despite the fact that I contacted this person via both email and IRC
twice, I have had no response or acknowledgement of my messages. I'm
not going to surmise or presume anything from this; instead, I'm
asking anyone who understands the FAT32 file system if they know of a
utility which might be able to fix these issues, or if they might be
otherwise able to help me out. I personally am NOT interested in
writing a Pacman clone for FAT32; I took one look at the dosfsck
internals, blinked a couple of times, and *bolted*; it is by no means
similar to the OS X FAT32 fsck utility; it's way more complex, and has
many more ideas about exactly how it'd like to chop up and dice my
broken filesystem. xD

After having to recently wipe my CF card I have been perhaps
understandably motivated to again seek a solution to this problem.

EPOCalypticFATfight.zip contains two disk images from my spare 16MB CF
card which exhibit this problem; I can generate more very easily.
IIRC, it also contains some screenshots of a disk utility running on
the PDA showing the raw FAT corruption, along with the entire contents
of stderr from a dosfsck run on an earlier card image. It can be
grabbed from: https://www.box.com/s/393ywij49mdwfu1e8apu

If you wouldn't mind carbon-copying asmqb7 at gmail (s/at/@/ ;
s/gmail/gmail.com/) (<-- measures taken to work around email-blocking
in mailing-list trawlers) in your reply(s), this would be much
appreciated since at the moment I'm less than enthused by the idea of
subscribing to LKML and being flooded with messages; I'd only end up
hiding them from my inbox, wasting bandwidth.

Thanks in advance!!

-i336
