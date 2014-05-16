Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421AbaEPDgg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 23:36:36 -0400
Received: from know-smtprelay-omc-8.server.virginmedia.net ([80.0.253.72]:47651
	"EHLO know-smtprelay-omc-8.server.virginmedia.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752616AbaEPDgf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 23:36:35 -0400
X-Originating-IP: [81.106.150.188]
X-Spam: 0
X-Authority: v=2.1 cv=TM7LSjVa c=1 sm=1 tr=0 a=DGj713NdaxKrsjjgQne7PA==:117
 a=DGj713NdaxKrsjjgQne7PA==:17 a=J0QyKEt1u0cA:10 a=g4btabCEvaAA:10
 a=uObrxnre4hsA:10 a=IkcTkHD0fZMA:10 a=NLZqzBF-AAAA:8 a=y5Yq1ZyPAAAA:8
 a=8XOKC7VvAAAA:8 a=3lASgbX8GMqyJOsG_BYA:9 a=QEXdDO2ut3YA:10 a=ZRMYnis2yrMA:10
 a=OQTSBD0adIkA:10 a=zYgc6MI35hkA:10
Date: Fri, 16 May 2014 04:36:32 +0100
From: Ken Moffat <zarniwhoop@ntlworld.com>
To: David Hagood <david.hagood@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Bug? Older 32 bit program (CivCTP) no longer works under 64 bit
 kernel
Message-ID: <20140516033632.GA30098@milliways>
References: <537568B5.9060208@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <537568B5.9060208@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2014 at 08:24:05PM -0500, David Hagood wrote:
> I have an old native Linux 32 bit copy of Civilization: Call to Power. It
> used to work under a 64 bit environment back in the 3.0.x days. However,
> under recent versions (>3.5) it no longer runs - it complains that it cannot
> find certain files in the directory. The exact same code will run just fine
> under a 32 bit version of 3.11. I have a Pentium II as well as the Core 2
> Duo, both running Ubuntu 14.04, same version of the kernel other than one is
> 32 bit and one is 64 bit. I've copied the files over from the 32 bit
> machine, where it runs, to the 64 bit machine, where it does not. I've even
> gone so far as to copy all the system 32 bit libraries into the CivCTP
> directory, and forced the program to use them (including using the
> ld-linux.so loader from that directory) - so in theory it's all the same
> user space libraries running - the only difference that I can see is that
> one kernel is 64 bit and one is 32 bit.
> 
> Running strace on the program shows that the directories being searched for
> game assets are corrupted:
> 
> 16218 stat64("/home/wowbaggr/CivCTP/ctdata/englisish/uidata/keymap.txt",
> <unfinished ...>
> 
> Note the "englisish" rather than "english".
> 
> I'm looking for any suggestions on where to look for what might cause such
> an issue - what can I do to start tracking this down.

 I've no ideas about what part of the kernel is causing this, so
I'll just offer you some thoughts on how to track it down.  At a
guess, you will have to run 'git bisect' to nail which change broke
this (or alternatively which change exposed a latent problem).

 Bisection is fairly well covered on google, for example it finds
http://landley.net/writing/git-bisect-howto.html

 The corrupt filename looks (to me, with no experience) like
something which might be in the filesystem area.  It probably isn't,
but I don't recall anything at all like this, so I'd better ask - are
you using an uncommon filesystem for this data ?  This looks like
such a grievous fault that I would expect someone to have noticed it
between 3.5.0 and now.

 And, have you tried any recent kernels (e.g. 3.14.4) to confirm
that the problem still exists ?  If it turns out that somebody
already fixed it, that would save you a lot of effort.

 You will need a network connection to clone linus' tree, and some
space for it.  And git, of course.  To bisect, you should build in
the git tree, AND set CONFIG_LOCALVERSION_AUTO - in
 General setup
  [ ] Automatically append version information to the version

so that the kernel version, and the version in /lib/modules, will
add -XXXXX-gYYYYYYYY information to each non-release install - that
is useful when you are bisecting, so that each set of modules is
kept separate.  See e.g.
http://yarchive.net/comp/linux/CONFIG_LOCALVERSION_AUTO.html

 It might speed this up if you can minimise the kernel config
(distros tend to build the whole kitchen sink as modules) - the
fewer unnecessary things you build, the less time it takes.

 Does it work on 3.4.0 ?  I know 3.4 is supported, and therefore
there are continuing releases with backported fixes, but for
bisection it is easiest to start testing with .0 releases.  If it
doesn't work there (I'm unclear if 3.5 was the earliest post-3.0
kernel that you tried), find which was the last .0 kernel where it
worked.  You can then label that version as "good", e.g.
 git bisect good v3.4 [ or whichever version - without the .0 ].

 Once you are certain which .0 version was the last which worked,
the next can be marked as bad, e.g. v3.5 - and then you bisect.

 Do not be surprised if the kernel identifies itself as an earlier
version than the last good one - see Linus's post referenced at
yarchive.net above.  And good luck, bisection is usually tedious.

ĸen
-- 
das eine Mal als Tragödie, dieses Mal als Farce
