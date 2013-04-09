Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936479Ab3DIVEg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 17:04:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39768 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936435Ab3DIVEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 17:04:34 -0400
Date: Tue, 9 Apr 2013 14:04:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Jan Kara <jack@suse.cz>, Mel Gorman <mgorman@suse.de>,
        Shuge <shugelinux@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-ext4@vger.kernel.org,
        Kevin <kevin@allwinnertech.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Jens Axboe <axboe@kernel.dk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3] [RESEND] mm: Make snapshotting pages for stable
 writes a per-bio operation
Message-Id: <20130409140432.cd69f999302a02caf73788fc@linux-foundation.org>
In-Reply-To: <20130409180617.GB8907@blackbox.djwong.org>
References: <20130409180617.GB8907@blackbox.djwong.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Apr 2013 11:06:17 -0700 "Darrick J. Wong" <darrick.wong@oracle.com> wrote:

> +		 * Here we write back pagecache data that may be mmaped. Since
> +		 * we cannot afford to clean the page and set PageWriteback
> +		 * here due to lock ordering (page lock ranks above transaction
> +		 * start), the data can change while IO is in flight. Tell the
> +		 * block layer it should bounce the bio pages if stable data
> +		 * during write is required.

I think there are already ab/ba deadlocks between lock_page() and
journal_start().  iirc one path was write(), I forget which was the
other path.  This was 10+ years ago and nobody else noticed and I
didn't know how to fix it so I didn't tell anyone ;)

It would be neat to be able to hook things like journal_start() into
lockdep but I don't think that lockdep has easy provision for wiring
oddball things into its mechanisms.

