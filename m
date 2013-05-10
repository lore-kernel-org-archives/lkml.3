Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389Ab3EJKW1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 06:22:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47641 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751561Ab3EJKW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 06:22:26 -0400
Date: Fri, 10 May 2013 11:22:24 +0100
From: Joe Thornber <thornber@redhat.com>
To: device-mapper development <dm-devel@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 2/2] dmcache: Implement a flush message
Message-ID: <20130510102224.GF20880@debian>
Mail-Followup-To: device-mapper development <dm-devel@redhat.com>,
	Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org
References: <20130508214845.GA7729@blackbox.djwong.org>
 <20130508220526.GA24132@redhat.com>
 <20130509203616.GA5713@blackbox.djwong.org>
 <20130509204751.GB5712@blackbox.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130509204751.GB5712@blackbox.djwong.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 09, 2013 at 01:47:51PM -0700, Darrick J. Wong wrote:
> Create a new 'flush' message that causes the dmcache to write all of its
> metadata out to disk.  This enables us to ensure that the disk reflects
> whatever's in memory without having to tear down the cache device.  This helps
> me in the case where I have a cached ro fs that I can't umount and therefore
> can't tear down the cache device, but want to save the cache metadata anyway.
> The command syntax is as follows:
> 
> # dmsetup message mycache 0 flush now

Nack.

[Ignoring the ugly 'now' parameter.]

I think you're in danger of hiding the real issue.  Which is if the
target's destructor and post suspend is not being called then, as far
as dm-cache is concerned this is a crash.  Any open transactions will
be lost as it automatically rolls back.

We need to understand more why this is happening.  It's actually
harmless atm for dm-cache, because we're forced to commit before using
a new migration.  But for dm-thin you can lose writes.  Why are you
never tearing down your dm devices?

- Joe
