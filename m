Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774Ab3COTkD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 15:40:03 -0400
Received: from barracuda.fsl.cs.sunysb.edu ([130.245.126.20]:42893 "EHLO
	barracuda.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752164Ab3COTkB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 15:40:01 -0400
X-Greylist: delayed 833 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Mar 2013 15:40:01 EDT
X-ASG-Debug-ID: 1363375564-01c65a78fa8f100001-xx1T2L
X-Barracuda-Envelope-From: ezk@fsl.cs.sunysb.edu
X-Barracuda-RBL-Trusted-Forwarder: 130.245.126.16
Subject: Re: [PATCH 0/9] overlay filesystem: request for inclusion (v17)
X-Barracuda-BWL-IP: 130.245.65.78
X-Barracuda-Apparent-Source-IP: 130.245.65.78
X-Barracuda-RBL-IP: 130.245.65.78
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
X-ASG-Orig-Subj: Re: [PATCH 0/9] overlay filesystem: request for inclusion (v17)
Content-Type: text/plain; charset=windows-1252
From: Erez Zadok <ezk@fsl.cs.sunysb.edu>
In-Reply-To: <29608.1363373838@jrobl>
Date: Fri, 15 Mar 2013 15:26:11 -0400
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, apw@canonical.com, nbd@openwrt.org, neilb@suse.de,
        jordipujolp@gmail.com, dhowells@redhat.com, sedat.dilek@googlemail.com,
        mszeredi@suse.cz
Content-Transfer-Encoding: 8BIT
Message-Id: <82F28802-467F-4B03-8965-49B3912676DE@fsl.cs.sunysb.edu>
References: <1363184193-1796-1-git-send-email-miklos@szeredi.hu> <20130313160854.54ac0491044371b4db214698@linux-foundation.org> <CAJfpeguvhJaoSBDKEXoJFn_C=52aXbC9L2ALJvp6ekwEGyQX_g@mail.gmail.com> <20130315012541.GU21522@ZenIV.linux.org.uk> <19058.1363320936@jrobl> <20130315044411.GW21522@ZenIV.linux.org.uk> <20079.1363324154@jrobl> <20130315051322.GX21522@ZenIV.linux.org.uk> <1363335318.2459.4.camel@dabdike> <20130315121220.GY21522@ZenIV.linux.org.uk> <29608.1363373838@jrobl>
To: "J. R. Okajima" <hooanon05@yahoo.co.jp>, Al Viro <viro@ZenIV.linux.org.uk>,
        Miklos Szeredi <miklos@szeredi.hu>, torvalds@linux-foundation.org
X-Mailer: Apple Mail (2.1499)
X-Barracuda-Connect: avatar.fsl.cs.sunysb.edu[130.245.126.16]
X-Barracuda-Start-Time: 1363375564
X-Barracuda-URL: http://barracuda.fsl.cs.sunysb.edu:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.125294
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I tend to agree with Al's and Linus's POV regarding whiteouts. There are three general techniques to implementing whiteouts:

1. namespace: special file names, hard/symlinks, or special "hidden" dot files.
2. extended attributes.
3. DT_WHT dirent flags.
(there's actually a 4th method I've tried before that I won't discuss below: implementing your own data structures on a raw partition — way too cumbersome.)

The namespace techniques require lower file systems to support hard/symlinks and sometimes need long names. A plus: they work on most file systems (but not all).  But they cause all sorts of namespace ugliness, where you have to hide the special file names, avoid them, ensure atomic updates for ops that involve whiteouts.  It's all doable, as had been demonstrated by several implementations.  But it's still icky in terms of namespace pollution.

The extended attributes technique, I think, is better than the namespace one in that you don't pollute the namespace; plus, I think the EA technique minimizes atomicity issues that show up with the namespace method.  Yet, it still requires EA support in lower file systems, so it won't work unless lower file systems support xattr ops.  Plus it could fail for file systems that have limited xattr support (e.g., number of EAs per inode).

The DT_WHT technique is the cleanest in the long run, and the best of the three IMHO.  It's well understood and has been done in BSD a long time ago.  It doesn't have the namespace pollution as seen in technique #1 above.  And I believe it also minimize atomicity issues.  Plus you won't have issues running out of EAs.

A while back I've looked at the unionmount code for DT_WHT support for ext2/tmpfs, and it was small, clean, and mostly additive.  I even had a prototype port of unionfs using unionmount's DT_WHT support: it was relatively easy to port unionfs to use DT_WHT instead of namespace techniques. Plus, I was able to reduce the amount of code devoted to whiteout support by quite a bit.

So I think it'll be easy to port overlayfs to use DT_WHT.  Given that most people use unioning with ext* and tmpfs, minimal DT_WHT support in those would get most users happy initially. And we can then let other file systems support DT_WHT on their own, in whatever way they deem suitable (as Al suggested, this is really best deferred to the F/S to implement).

Lastly, what I'm not sure is what API to use for whiteouts: should every f/s implement some new methods to add/remove/query a whiteout, or should the upper f/s and VFS directly check DT_WHT flags with S_ISWHT.  The generic f/s methods may allow file systems to implement whiteouts in arbitrary ways, not necessarily as a dirent flag.

Cheers,
Erez.

