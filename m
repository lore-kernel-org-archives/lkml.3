Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757474AbaLIPOd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 10:14:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36425 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751940AbaLIPOb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 10:14:31 -0500
Date: Tue, 9 Dec 2014 15:12:53 +0000
From: Joe Thornber <thornber@redhat.com>
To: device-mapper development <dm-devel@redhat.com>
Cc: gregkh@linuxfoundation.org, snitzer@redhat.com, agk@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] [PATCH] staging: writeboost: Add dm-writeboost
Message-ID: <20141209151253.GA17660@debian>
Mail-Followup-To: device-mapper development <dm-devel@redhat.com>,
	gregkh@linuxfoundation.org, snitzer@redhat.com, agk@redhat.com,
	linux-kernel@vger.kernel.org
References: <5484498E.4000202@gmail.com>
 <20141207200834.GA2322@kroah.com>
 <5484C0E9.3060707@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5484C0E9.3060707@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 08, 2014 at 06:04:41AM +0900, Akira Hayakawa wrote:
> Mike and Alasdair,
> I need your ack

Hi Akira,

I just spent some time playing with your latest code.  On the positive
side I am seeing some good performance with the fio tests.  Which is
great, we know your design should outperform dm-cache with small
random io.

However I'm still getting v. poor results with the git-extract test,
which clones a linux kernel repo, and then checks out 5 revisions, all
with drop_caches in between.

I'll summarise the results I get here:


    raw SSD:            69, 107
    raw spindle:        73, 184

    dm-cache:           74, 118

    writeboost type 0:  115, 247
    writeboost type 1:  193, 275


Each result consists of two numbers, the time to do the clone and the
time to do the extract.

Writeboost is significantly slower than the spindle alone for this
very simple test.  I do not understand what is causing the issue.  At
first I thought it was because the working set is larger than the SSD
space, but I get the same results even if there's more SSD space than
spindle.

Running the same test using SSD on SSD also yields v. poor results:
115, 177 and 198, 218 for type 0 and type 1 respectively.  Obviously
this is a pointless configuration, but it does allow us to see the
overhead of the caching layer.

It's fine to have different benefits of the caching software depending
on the load.  But I think the worst case should always be close to the
performance of the raw spindle device.

If you get the following work items done I will ack to go upstream:

i) Get this test so it's performance is similar to raw spindle.

ii) Write good documentation in Documentation/device-mapper/.  eg. How
    do I remove a cache?  When should I use dm-writeboost rather than
    bcache or dm-cache?

iii) Provide an equivalent to the fsck tool to repair a damaged cache.

- Joe
