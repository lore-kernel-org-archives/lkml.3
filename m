Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050Ab3IZHdI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 03:33:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54249 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755917Ab3IZHdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 03:33:06 -0400
Date: Thu, 26 Sep 2013 00:33:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org,
        Tejun Heo <tj@kernel.org>
Subject: Re: increased vmap_area_lock contentions on
 "n_tty: Move buffers into n_tty_data"
Message-Id: <20130926003315.2e81bc84.akpm@linux-foundation.org>
In-Reply-To: <5238F252.5070905@hurleysoftware.com>
References: <20130913005133.GA32479@localhost>
	<20130913010936.GA1291@localhost>
	<5238767D.1080606@hurleysoftware.com>
	<20130917232214.GA11390@localhost>
	<5238F252.5070905@hurleysoftware.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Sep 2013 20:22:42 -0400 Peter Hurley <peter@hurleysoftware.com> wrote:

> Looking over vmalloc.c, the critical section footprint of the vmap_area_lock
> could definitely be reduced (even nearly eliminated), but that's a project for
> another day :)

20bafb3d23d10 ("n_tty: Move buffers into n_tty_data") switched a
kmalloc (which is very fast) to a vmalloc (which is very slow) without
so much as mentioning it in the changelog.  This should have been
picked up at review, btw.

Revert that part of the patch and the problem will be solved.

If we are really really worried that a ~9k kmalloc might fail or will
be slow, then implement a fallback to vmalloc() if kmalloc(GFP_NOWARN)
failed.  This kinda sucks, but is practical, but really should only be
done if necessary - ie, if problems with using plain old kmalloc are
demonstrable.

Or just revert all of 20bafb3d23d10 - it was supposed to be a small
performance improvement but turned out to be a significant performance
loss.  Therefore zap.

