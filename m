Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932091Ab3BZQUa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 11:20:30 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:47903 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759155Ab3BZQU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 11:20:28 -0500
Date: Tue, 26 Feb 2013 16:20:24 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-security-module <linux-security-module@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ima: prevent dead lock when a file is opened for direct
 io
Message-ID: <20130226162024.GI4503@ZenIV.linux.org.uk>
References: <1361395671.29360.26.camel@falcor1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361395671.29360.26.camel@falcor1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 04:27:51PM -0500, Mimi Zohar wrote:
> Hi Al,
> 
> Are there any negative repercussions to temporarily removing the
> o_direct flag in order to calculate the file hash?
> 
> thanks,
> 
> Mimi
> -----
> 
> Files are measured or appraised based on the IMA policy.  When a file
> in policy is opened for read with the O_DIRECT flag set, a deadlock
> occurs due to do_blockdev_direct_IO() taking i_mutex before calling
> filemap_write_and_wait_range(). The i_mutex was previously taken in
> process_measurement().  This patch temporarily removes the O_DIRECT
> flag in order to calculate the hash and restores it once completed.

	Why does process_measurement() hold ->i_mutex across that?
It really sounds like "we kinda hope no ->read() will take ->i_mutex,
oops, at least one case does, umm... let's kludge around a bit and
hope no other case shows up".  

Locking rules should be documented and they should make sense.  You are
introducing a new one and it's really convoluted - "no ->read() instance
for a regular file shall take ->i_mutex unless it's an O_DIRECT open".
