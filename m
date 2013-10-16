Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935329Ab3JPSMl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 14:12:41 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:51237 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935315Ab3JPSMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 14:12:38 -0400
Date: Wed, 16 Oct 2013 11:12:34 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Jones <davej@redhat.com>,
        xfs@oss.sgi.com, Linux Kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: fs/attr.c:notify_change locking warning.
Message-ID: <20131016181234.GA26646@infradead.org>
References: <20131005005210.GA25773@redhat.com>
 <20131005031918.GL4446@dastard>
 <20131015201905.GA7509@infradead.org>
 <20131015213618.GU4446@dastard>
 <20131016070528.GB18721@infradead.org>
 <20131016102651.GF4446@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131016102651.GF4446@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 09:26:51PM +1100, Dave Chinner wrote:
> The killpriv calls? I couldn't find anything that implemented those
> security hooks nor any documentation about it, so I'm pretty much
> clueless about it. FWIW, ocfs2 doesn't implement them, either....

The killpriv code ends up doing xattr calls for per-file capabilities
(grep security/commoncap.c for killpriv).  Seems like ocfs2 is buggy in
that regard.

I suspect the easiest way to solve it properly in XFS is to simply
retake the iolock exclusive and get the i_mutex as part of it.  This
means direct I/O writes to files with the suid bit won't scale, but I
think we can live with that given that it avoids introducing special
cases that impact more code.

