Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388Ab3I0Snn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 14:43:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45940 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754084Ab3I0Snl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 14:43:41 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] blktrace: fix race with open trace files and directory removal
References: <52425444.204@suse.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Fri, 27 Sep 2013 14:43:29 -0400
In-Reply-To: <52425444.204@suse.com> (Jeff Mahoney's message of "Tue, 24 Sep
	2013 23:11:00 -0400")
Message-ID: <x49k3i2ds1a.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Mahoney <jeffm@suse.com> writes:

> There's a bug in the blktrace client where it will stop and tear down
> all of the tracing instances for devices it's opened whether it
> successfully completed the setup or not.
>
> By starting multiple blktrace processes on the same device, it's possible
> to permanently disable blktrace on that device. The cause is that when
> the first blktrace process to exit tears down the directory structure,
> the trace files are still held open. Debugfs removes the dentries for the
> open files just fine but the relay implementation doesn't remove the
> dentries until all of the references to the file are dropped. This means
> that if there are open files when debugfs_remove is called for the device
> directory, the directory is not empty and can't be removed. Since the
> shutdown of the blktrace structure xchg's the structure out, there's no
> way to clean up the directory and any new blktrace processes will fail
> to start because it can't create the directory.
>
> This patch adds a kref to blk_trace so that we can release it after the
> initial reference as well as all of the references accumulated by the
> relay files are dropped.

Can't we just do proper unwinding of errors in the do_blktrace_setup
function?  In other words, don't just blindly call blk_trace_free, but
instead just undo anything we've done.

Cheers,
Jeff
