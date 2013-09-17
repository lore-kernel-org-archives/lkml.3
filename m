Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787Ab3IQMnY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 08:43:24 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:52020 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124Ab3IQMnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 08:43:22 -0400
Message-ID: <52384E66.6050101@gmail.com>
Date: Tue, 17 Sep 2013 21:43:18 +0900
From: Akira Hayakawa <ruby.wktk@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: snitzer@redhat.com
CC: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com, cesarb@cesarb.net,
        joe@perches.com, akpm@linux-foundation.org, agk@redhat.com,
        m.chehab@samsung.com
Subject: Re: staging: Add dm-writeboost
References: <5223208D.4000008@gmail.com> <20130916215357.GA5015@redhat.com>
In-Reply-To: <20130916215357.GA5015@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Mike

There are two designs in my mind
regarding the formatting cache.

You said
>   administer the writeboost devices.  There is no need for this.  Just
>   have a normal DM target whose .ctr takes care of validation and
>   determines whether a device needs formatting, etc.  
makes me wonder how I format the cache device.


There are two choices for formatting cache and create a writeboost device
standing on the point of removing writeboost-mgr existing in the current design.
I will explain them from how the interface will look like.

(1) dmsetup create myDevice ... "... $backing_path $cache_path"
which will returns error if the superblock of the given cache device
is invalid and needs formatting.
And then the user formats the cache device by some userland tool.

(2) dmsetup create myDevice ... "... $backing_path $cache_path $do_format"
which also returns error if the superblock of the given cache device
is invalid and needs formatting when $do_format is 0.
And then user formats the cache device by setting $do_format to 1 and try again.

There pros and cons about the design tradeoffs:
- (i)  (1) is simpler. do_format parameter in (2) doesn't seem to be sane.
       (1) is like the interfaces of filesystems where dmsetup create is like mounting a filesystem.
- (ii) (2) can implement everything in kernel. It can gather all the information
       about how the superblock in one place, kernel code.

Excuse for the current design:
- The reason I design writeboost-mgr is almost regarding (ii) above.
  writeboost-mgr has a message "format_cache_device" and
  writeboost-format-cache userland command kicks the message to format cache.

- writeboost-mgr has also a message "resume_cache"
  that validates and builds a in-memory structure according to the cache binding to given $cache_id
  and user later dmsetup create the writeboost device with the $cache_id.
  However, resuming the cache metadata should be done under .ctr like dm-cache does
  and should not relate LV to create and cache by external cache_id
  is what I realized by looking at the code of dm-cache which
  calls dm_cache_metadata_open() routines under .ctr .
  I don't know why I should not do this it is nicer to trust DM guys in RedHat on this point.

writeboost-mgr is something like smell of over-engineering but
is useful for simplifying the design for above reasons.


Which do you think better?

Akira

