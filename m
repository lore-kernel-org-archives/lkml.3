Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751800Ab3BOUGC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 15:06:02 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:54177 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911Ab3BOUGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 15:06:00 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <greg@kroah.com>
Subject: Re: linux-next: build warning after merge of the char-misc tree
Date: Fri, 15 Feb 2013 20:05:51 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-6-generic; KDE/4.3.2; x86_64; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Stevenson <david@avoncliff.com>
References: <20130215162657.6dd03d27e8cfed0c134b5dd3@canb.auug.org.au> <20130215173429.GA27707@kroah.com>
In-Reply-To: <20130215173429.GA27707@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201302152005.51575.arnd@arndb.de>
X-Provags-ID: V02:K0:fDNSf9Em4/XBPOZ1ErbrLb4i1UMvsUZQUp45hjsdQVq
 bjGmovVTPaUZV1WlSzjzabC/2E7dRmnKeHMNYY+YFd4liRtn59
 h8U4o0kY22KGV0mL5+U/4I4lvGp4b82d/4iCNDsfjGSgqp94Gi
 CgvRVAarV49KxmXQMzkai3eojlPMyZWH4qZsBJfp8Xv8+QpaNg
 KYUAoKh9W9PfN18tJSvt9UbrwGpmdHivtxJHg/PBZOEt95/uXs
 5niTihl3X7coWr5vow+pQZFW2zvywvXiEPqsnhg+TJ4/gWU1T9
 knVEOxwyJ022XY1VB3YGAvwb2OsxwfZvdNkvBJSUXPR49/aud5
 p9NbFXmBsSOQSJFjUt7A=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 February 2013, Greg KH wrote:
> On Fri, Feb 15, 2013 at 04:26:57PM +1100, Stephen Rothwell wrote:
> > 
> > After merging the char-misc tree, today's linux-next build (x86_64
> > allmodconfig) produced this warning:
> > 
> > drivers/w1/slaves/w1_therm.c: In function 'w1_therm_read':
> > drivers/w1/slaves/w1_therm.c:245:15: warning: 'crc' may be used uninitialized in this function [-Wuninitialized]
> > 
> > Its a false positive, but it was introduced by commit 867ff9880d5d
> > ("w1_therm: Retries: remove old code add CRC")
> 
> I don't see that here with gcc 4.7.1, perhaps you need to upgrade your
> version of gcc to not show these false positives?

I have finally put the pieces of the puzzle together. I already knew
that some of these warnings only happen when building with -Os (even
in gcc-4.8), since gcc turns off the inlining at a point after it
determines that the variable might be used uninitialized but before
determining that it's actually isn't.

I think the best way forward is to disable this particular warning
when building with -Os (which is enabled in allyesconfig). A false
positive seems more harmful than a false negative here, because it
prompts people to add broken initializations. This patch indeed
makes the majority of the allyesconfig warnings on ARM go away.
For the regular defconfig builds, we are already mostly clean,
and those are built with -O2.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/Makefile b/Makefile
index 0b4bf62..4d60d97 100644
--- a/Makefile
+++ b/Makefile
@@ -570,7 +570,7 @@ endif # $(dot-config)
 all: vmlinux
 
 ifdef CONFIG_CC_OPTIMIZE_FOR_SIZE
-KBUILD_CFLAGS	+= -Os
+KBUILD_CFLAGS	+= -Os $(call cc-option,-Wno-maybe-uninitialized,)
 else
 KBUILD_CFLAGS	+= -O2
 endif
