Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934286Ab3BMPzQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 10:55:16 -0500
Received: from mail.avalus.com ([89.16.176.221]:38236 "EHLO mail.avalus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934236Ab3BMPzO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 10:55:14 -0500
Subject: Re: [PATCH 1/3] nbd: support FLUSH requests
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Alex Bligh <alex@alex.org.uk>
In-Reply-To: <511B8E65.5020507@redhat.com>
Date: Wed, 13 Feb 2013 15:55:01 +0000
Cc: Alex Bligh <alex@alex.org.uk>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, nbd-general@lists.sf.net,
        Paul Clements <Paul.Clements@steeleye.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <3EDEF735-9A67-439E-BA65-089C6AAFD1BF@alex.org.uk>
References: <1360685171-3792-1-git-send-email-pbonzini@redhat.com> <1360685171-3792-2-git-send-email-pbonzini@redhat.com> <115932E2-48BE-406E-9E75-61D12EB5937A@alex.org.uk> <511A8491.5030407@redhat.com> <20130212133207.ef6b24f5.akpm@linux-foundation.org> <FF1216D8-C4B3-405E-A4F6-82196A796A94@alex.org.uk> <511B8E65.5020507@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paolo,

On 13 Feb 2013, at 13:00, Paolo Bonzini wrote:

> But as far as I can test with free servers, the FUA bits have no
> advantage over flush.  Also, I wasn't sure if SEND_FUA without
> SEND_FLUSH is valid, and if so how to handle this combination (treat it
> as writethrough and add FUA to all requests? warn and do nothing?).

On the main opensource nbd client, the following applies:

What REQ_FUA does is an fdatasync() after the write. Code extract and
comments below from Christoph Hellwig.

What REQ_FLUSH does is to do an fsync().

The way I read Christoph's comment, provided the linux block layer always
issues a REQ_FLUSH before a REQ_FUA, there is not performance problem.

However, a REQ_FUA is going to do a f(data)?sync AFTER the write, whereas
the preceding REQ_FLUSH is going to an fsync() BEFORE the write. It seems
to me that either the FUA and FLUSH semantics are therefore different
(and we need FUA), or that Christoph's comment is wrong and that you
are guaranteed a REQ_FLUSH *after* the write with REQ_FUA.

-- 
Alex Bligh




        } else if (fua) {

          /* This is where we would do the following
           *   #ifdef USE_SYNC_FILE_RANGE
           * However, we don't, for the reasons set out below
           * by Christoph Hellwig <hch@infradead.org>
           *
           * [BEGINS] 
           * fdatasync is equivalent to fsync except that it does not flush
           * non-essential metadata (basically just timestamps in practice), but it
           * does flush metadata requried to find the data again, e.g. allocation
           * information and extent maps.  sync_file_range does nothing but flush
           * out pagecache content - it means you basically won't get your data
           * back in case of a crash if you either:
           * 
           *  a) have a volatile write cache in your disk (e.g. any normal SATA disk)
           *  b) are using a sparse file on a filesystem
           *  c) are using a fallocate-preallocated file on a filesystem
           *  d) use any file on a COW filesystem like btrfs
           * 
           * e.g. it only does anything useful for you if you do not have a volatile
           * write cache, and either use a raw block device node, or just overwrite
           * an already fully allocated (and not preallocated) file on a non-COW
           * filesystem.
           * [ENDS]
           *
           * What we should do is open a second FD with O_DSYNC set, then write to
           * that when appropriate. However, with a Linux client, every REQ_FUA
           * immediately follows a REQ_FLUSH, so fdatasync does not cause performance
           * problems.
           *
           */
#if 0
                sync_file_range(fhandle, foffset, len,
                                SYNC_FILE_RANGE_WAIT_BEFORE | SYNC_FILE_RANGE_WRITE |
                                SYNC_FILE_RANGE_WAIT_AFTER);
#else
                fdatasync(fhandle);
#endif
        }


