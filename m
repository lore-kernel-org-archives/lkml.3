Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741AbaHEPYr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 11:24:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32437 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751173AbaHEPYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 11:24:45 -0400
Date: Tue, 5 Aug 2014 17:24:27 +0200
From: Jakub Jelinek <jakub@redhat.com>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Josh Boyer <jwboyer@fedoraproject.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Michel =?iso-8859-1?Q?D=E4nzer?= <michel@daenzer.net>
Subject: Re: [PATCH 3.15 33/37] Fix gcc-4.9.0 miscompilation of
 load_balance() in scheduler
Message-ID: <20140805152427.GX7393@tucnak.redhat.com>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <20140730014827.565626091@linuxfoundation.org>
 <20140730014829.344302554@linuxfoundation.org>
 <20140730065312.GA1652@laptop.redhat.com>
 <CA+55aFzr_wJzt6RpojXpDo-ashV_N7sP+j7Ba0ND9mSpr7MKRQ@mail.gmail.com>
 <CA+5PVA5FPD8hp_7=M-VNoUG1Mw9R0Xkn2Yo50eo28ojzrcB5Aw@mail.gmail.com>
 <20140805114649.GA295@x4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140805114649.GA295@x4>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2014 at 01:46:49PM +0200, Markus Trippelsdorf wrote:
> On 2014.08.05 at 07:31 -0400, Josh Boyer wrote:
> > Sorry to bring this back up after the fact, but it's important for a
> > number of things in various distros.  I don't disagree it should be
> > disabled by default, but making it unconditional is going to force the
> > distributions that care about perf, systemtap, and debuggers to
> > manually revert this.  That deviation is concerning because the
> > upstream kernel won't easily be buildable the same way distros build
> > it.
> > 
> > I'm happy to come up with a config option patch, but I'm not sure if
> > it would be accepted.  Is that a possibility at this point?
> 
> Please note that https://gcc.gnu.org/bugzilla/show_bug.cgi?id=61923

But that isn't a wrong-code bug, in some cases it is no code generation difference
between -g and -g0 at all (just :TI on the dumps being different), in some
cases it can affect scheduling decisions for real, but still not in a way
that disregards the actual dependencies in between instructions.  You can
get such scheduling differences also if you just use slightly different
compiler revision.

> isn't fixed yet. So it would be premature to manually revert Linus'
> patch yet. 
> 
> When PR61923 gets fixed (and backported) its testcase could be combined
> with the testcase Jakub posted earlier in this thread.

Just some data to show that the debug info differences are nothing close to
insignificant.  I've built a 3.16 kernel (from Fedora 21 rpm) both normally
(which includes the -fno-var-tracking-assignments change) and with that line
in Makefile commented out.  E.g. on fs/ext4/ext4.o, dwlocstat says for
-fno-var-tracking-assignments:
dwlocstat --tabulate=0.0:10,99,100 fs/ext4/ext4.o
cov%	samples	cumul
0.0	19620/75%	19620/75%
0..10	518/1%	20138/77%
11..20	317/1%	20455/78%
21..30	362/1%	20817/79%
31..40	349/1%	21166/81%
41..50	240/0%	21406/82%
51..60	297/1%	21703/83%
61..70	293/1%	21996/84%
71..80	355/1%	22351/85%
81..90	402/1%	22753/87%
91..99	901/3%	23654/90%
100	2425/9%	26079/100%
and without it:
dwlocstat --tabulate=0.0:10,99,100 fs/ext4/ext4.o
cov%	samples	cumul
0.0	8697/33%	8697/33%
0..10	431/1%	9128/35%
11..20	371/1%	9499/36%
21..30	608/2%	10107/38%
31..40	525/2%	10632/40%
41..50	461/1%	11093/42%
51..60	881/3%	11974/45%
61..70	678/2%	12652/48%
71..80	894/3%	13546/51%
81..90	1036/3%	14582/55%
91..99	949/3%	15531/59%
100	10548/40%	26079/100%

So, with -fno-var-tracking-assignments, about 75% of parameters/variables have
no location info at all in ext4.o, 9% of parameters/variables have coverage
for all instructions where the parameter/variable is in scope, the rest
something in between.  Without -fno-var-tracking-assignments, only 33% of
params/vars have no location info at all, and 40% have coverage on all
instructions where they are in scope.  Even for the params/vars without 100%
coverage there can be seen improvements, e.g. in the 51%-90% coverage.

Or e.g. -fno-var-tracking-assignments:
dwlocstat --tabulate=0.0:10,99,100 lib/built-in.o
cov%	samples	cumul
0.0	6323/64%	6323/64%
0..10	144/1%	6467/66%
11..20	138/1%	6605/67%
21..30	123/1%	6728/68%
31..40	144/1%	6872/70%
41..50	169/1%	7041/72%
51..60	130/1%	7171/73%
61..70	146/1%	7317/74%
71..80	198/2%	7515/76%
81..90	258/2%	7773/79%
91..99	541/5%	8314/85%
100	1448/14%	9762/100%
without -fno-var-tracking-assignments:
dwlocstat --tabulate=0.0:10,99,100 lib/built-in.o
cov%	samples	cumul
0.0	2954/30%	2954/30%
0..10	131/1%	3085/31%
11..20	110/1%	3195/32%
21..30	141/1%	3336/34%
31..40	212/2%	3548/36%
41..50	226/2%	3774/38%
51..60	254/2%	4028/41%
61..70	237/2%	4265/43%
71..80	325/3%	4590/47%
81..90	420/4%	5010/51%
91..99	425/4%	5435/55%
100	4328/44%	9763/100%

It is visible also e.g. in the section sizes on vmlinux:
-fno-var-tracking-assignments:
readelf -WS vmlinux 2>&1 | awk '/\.debug_/{printf "%s %fMB\n", $2, strtonum("0x"$6)/1024.0/1024.0}'
.debug_aranges 0.115387MB
.debug_info 96.625183MB
.debug_abbrev 2.585021MB
.debug_line 5.936069MB
.debug_frame 1.710655MB
.debug_str 1.956143MB
.debug_loc 8.713246MB
.debug_ranges 3.020081MB
without -fno-var-tracking-assignments:
readelf -WS vmlinux 2>&1 | awk '/\.debug_/{printf "%s %fMB\n", $2, strtonum("0x"$6)/1024.0/1024.0}'
.debug_aranges 0.115387MB
.debug_info 99.564449MB
.debug_abbrev 2.665213MB
.debug_line 5.936069MB
.debug_frame 1.710655MB
.debug_str 1.955960MB
.debug_loc 22.607447MB
.debug_ranges 3.020264MB

.debug_info growth is only very small (not even 3MB), only few vars have the
same value everywhere, but .debug_loc growth is significant (2.6 times
bigger).

	Jakub
