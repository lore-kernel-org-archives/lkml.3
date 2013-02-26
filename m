Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932650Ab3BZTor (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 14:44:47 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:39711 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759878Ab3BZTop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 14:44:45 -0500
Message-ID: <1361907128.2908.180.camel@falcor1.watson.ibm.com>
Subject: Re: [PATCH] ima: prevent dead lock when a file is opened for direct
 io
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-security-module <linux-security-module@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Tue, 26 Feb 2013 14:32:08 -0500
In-Reply-To: <20130226162024.GI4503@ZenIV.linux.org.uk>
References: <1361395671.29360.26.camel@falcor1>
	 <20130226162024.GI4503@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13022619-2398-0000-0000-00001183291E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-02-26 at 16:20 +0000, Al Viro wrote:
> On Wed, Feb 20, 2013 at 04:27:51PM -0500, Mimi Zohar wrote:
> > Hi Al,
> > 
> > Are there any negative repercussions to temporarily removing the
> > o_direct flag in order to calculate the file hash?
> > 
> > thanks,
> > 
> > Mimi
> > -----
> > 
> > Files are measured or appraised based on the IMA policy.  When a file
> > in policy is opened for read with the O_DIRECT flag set, a deadlock
> > occurs due to do_blockdev_direct_IO() taking i_mutex before calling
> > filemap_write_and_wait_range(). The i_mutex was previously taken in
> > process_measurement().  This patch temporarily removes the O_DIRECT
> > flag in order to calculate the hash and restores it once completed.
> 
> 	Why does process_measurement() hold ->i_mutex across that?

Before anything gets access to the file, the file needs to be measured,
appraised, and/or audited, based on policy.  If IMA-appraisal is enabled
and the file is in policy, we enforce local file integrity and return
-EINVAL on failure, similar to LSMs.

Appraising the file is a two step process.  Before appraising the file
data's integrity, we verify the integrity of the file metadata. Included
in the 'security.evm' calculation is the ino, generation, uid, gid,
mode, uuid, and the security xattrs.  'security.ima' contains the file
data hash or a signature based on the hash.

The i_mutex is held when making file metadata changes (eg. xattrs,
chmod, ...).  We hold the i_mutex through the entire verification,
preventing the file data/metadata from changing.

> It really sounds like "we kinda hope no ->read() will take ->i_mutex,
> oops, at least one case does, umm... let's kludge around a bit and
> hope no other case shows up".  
> 
> Locking rules should be documented and they should make sense.  You are
> introducing a new one and it's really convoluted - "no ->read() instance
> for a regular file shall take ->i_mutex unless it's an O_DIRECT open".

I guess I wasn't clear here.  IMA always takes the i_mutex, regardless
of the O_DIRECT flag.  When a file is opened for read,
process_measurement() takes the i_mutex and then, if the file was opened
with the O_DIRECT flag, do_blockdev_direct_IO() attempts to take the
i_mutex again, causing the lockdep.

Other than fiddling with the O_DIRECT flag, do you have any other
suggestions?

thanks,

Mimi

