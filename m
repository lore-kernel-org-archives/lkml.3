Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736AbaEaIpG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 04:45:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53089 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751789AbaEaIpC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 04:45:02 -0400
Message-ID: <538995D4.9050702@zytor.com>
Date: Sat, 31 May 2014 01:41:56 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, joseph@codesourcery.com,
        john.stultz@linaro.org, hch@infradead.org, tglx@linutronix.de,
        geert@linux-m68k.org, lftan@altera.com, linux-fsdevel@vger.kernel.org,
        xfs@oss.sgi.com
Subject: Re: [RFC 11/32] xfs: convert to struct inode_time
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de> <1401480116-1973111-12-git-send-email-arnd@arndb.de> <20140531003712.GH14410@dastard> <5389252A.5050503@zytor.com> <20140531011450.GJ14410@dastard> <c7770275-61de-4e94-9586-5ee118f77ba5@email.android.com> <20140531055457.GK14410@dastard>
In-Reply-To: <20140531055457.GK14410@dastard>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2014 10:54 PM, Dave Chinner wrote:
> 
> If we are changing the in-kernel timestamp to have a greater dynamic
> range that anything we current support on disk, then we need support
> for all filesystems for similar translation and constraint. The
> filesystems need to be able to tell the kernel what they timestamp
> range they support, and then the kernel needs to follow those
> guidelines. And if the filesystem is mounted on a kernel that
> doesn't support the current filesystem's timestamp format, then at
> minimum that filesystem cannot do anything that writes a
> timestamp....
> 
> Put simply: the filesystem defines the timestamp range that can be
> used safely, not the userspace API. If the filesystem can't support
> the date it is handed then that is an out-of-range error. Since
> when have we accepted that it's OK to handle out-of-range data with
> silent overflows or corruption of the data that we are attempting to
> store? We're defining a new API to support a wider date range -
> there is nothing that prevents us from saying ERANGE can be returned
> to a timestamp that the file cannot store correctly....
> 

I'm still puzzled.

Are you saying that you want a program that does:

	/* Deliberately simplified */
	gettimeofdayns(&now ...);
	utimensat(... now);

... to suddenly start failing on Jan 19, 2038 (for a filesystem with
32-bit timestamps), or would you propose some ways for the filesystems
in question to extend the range of the timestamps?

What you seem to propose also seems to imply that on Jan 19, 2038
anything that writes a timestamp with the current date (which logically
ends up being almost every write operation) would be dead and frozen on
such a filesystem -- pretty much meaning the filesystem would become
readonly if not in reality than in practice.

I strongly suspect that that would be a more catastrophic failure than
incorrect timestamps, as you suddenly have all kinds of machines
embedded in $DEITY knows what places just stop and refuse to run.

If that is not what you mean I genuinely like to understand the
situation better.

	-hpa

