Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751692Ab3LLGls (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 01:41:48 -0500
Received: from alt-proxy3.mail.unifiedlayer.com ([74.220.205.131]:42153 "HELO
	alt-proxy3.mail.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751198Ab3LLGlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 01:41:46 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Dec 2013 01:41:46 EST
Message-ID: <1386830101.3972.27.camel@slavad-ubuntu>
Subject: Re: [PATCH] hfsplus: Remove hfsplus_file_lookup
From: Vyacheslav Dubeyko <slava@dubeyko.com>
Reply-To: slava@dubeyko.com
To: Anton Altaparmakov <aia21@cam.ac.uk>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Sougata Santra <sougata@tuxera.com>,
        Christoph Hellwig <hch@infradead.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org Mailing List" 
	<linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org,
        Szabolcs Szakacsits <szaka@tuxera.com>
Date: Thu, 12 Dec 2013 10:35:01 +0400
In-Reply-To: <8B102D87-1A22-4ACA-9438-CA66133C2AB1@cam.ac.uk>
References: <1386780980.9524.10.camel@ultrabook>
	 <AE333CDA-DD74-42B8-92F4-551ACCAD8AFA@dubeyko.com>
	 <20131211191153.GZ10323@ZenIV.linux.org.uk>
	 <8B102D87-1A22-4ACA-9438-CA66133C2AB1@cam.ac.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Identified-User: {2172:host202.hostmonster.com:dubeykoc:dubeyko.com} {sentby:smtp auth 109.188.127.108 authed with slava@dubeyko.com}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-12-11 at 21:08 +0000, Anton Altaparmakov wrote:
> Hi,
> 
> On 11 Dec 2013, at 19:11, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > On Wed, Dec 11, 2013 at 10:49:29PM +0300, Vyacheslav Dubeyko wrote:
> >> This feature worked earlier under Linux. So, I suppose that some changes in HFS+ driver
> >> or in VFS broke it. And it needs to investigate and fix the reported issue. Thank you for the
> >> report.
> > 
> > This "feature" is severely broken and yes, outright removal is what I'd
> > suggest for a fix.  HFS+ allows hardlinks to files, which means that
> > you allow multiple dentries for the same inode with ->lookup() in it,
> > which is asking for deadlocks.
> > 
> > This is fundamentally not supported.  Considering that forks are lousy
> > idea in the first place, I'd seriously suggest to remove that idiocy for
> > good.
> 
> Completely agree with Al.  If anyone really wants access to forks they can implement them via the xattr interface (ok it has the 64k limitation but most forks are quite small so not much of an issue).  That's how I implemented access to named streams in Tuxera NTFS and it works a treat (and allows Linux apps and various security modules that require xattr support to work properly which is also great).
> 

Yes, I have the same considerations about using xattr way for the case
of resource fork after the night.

Usually, a file under HFS+ has or valid data fork, or valid resource
fork. So, HFS+ compressed file has valid resource fork only. Also alias
under Mac OS X has valid resource fork only. Of course, regular file can
have as valid data fork as valid resource fork. Fortunately, such case
is rare now (when file has both forks are valid). So, we can use xattr
way for accessing resource fork for such files. For example, it is
possible to use "osx.ResourceFork" xattr's name. And I suppose that 64
KB is reasonable limitation. Now we have access to FinderInfo fields of
CatalogFile's record for file under HFS+ by means of
"com.apple.FinderInfo" xattr.

I think that I can implement support of resource forks by means of xattr
way. Also, currently, I am implementing HFS+ compressed files support.
So, I can clean up old-fashioned way of resource forks support in HFS+
driver because of necessity to rework it anyway. The suggested patch
doesn't make all necessary cleanup, from my viewpoint.

Any comments?

Thanks,
Vyacheslav Dubeyko.


