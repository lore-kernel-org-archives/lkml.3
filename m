Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759AbaCQEk3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 00:40:29 -0400
Received: from ozlabs.org ([203.10.76.45]:33058 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750860AbaCQEjc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 00:39:32 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Josh Triplett <josh@joshtriplett.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Randy Dunlap <rdunlap@infradead.org>, mm-commits@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-next@vger.kernel.org,
        virtio-dev@lists.oasis-open.org, "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: mmotm 2014-03-10-15-35 uploaded (virtio_balloon)
In-Reply-To: <20140311214014.GA18708@leaf>
References: <20140310223701.0969C31C2AA@corp2gmr1-1.hot.corp.google.com> <531F43F2.1030504@infradead.org> <20140311110338.333e1ee691cadb0f20dbb083@linux-foundation.org> <20140311192046.GA2686@leaf> <20140311123133.f40adf3154452e82aecb61ca@linux-foundation.org> <20140311214014.GA18708@leaf>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Mon, 17 Mar 2014 14:02:31 +1030
Message-ID: <877g7tts8g.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Josh Triplett <josh@joshtriplett.org> writes:
> On Tue, Mar 11, 2014 at 12:31:33PM -0700, Andrew Morton wrote:
> I'd love to do that, but as far as I can tell, VIRTIO_BALLOON has gone
> out of its way to support !CONFIG_BALLOON_COMPACTION.
>
> Could someone who works on VIRTIO_BALLOON provide some details here
> about the distinction?

Balloon gives pages back to the host.  If you want to do compaction,
we'll try to help you, but it's independent.

The normal way to do this would be to put a dummy inline version of
balloon_page_enqueue etc in the header.  If you look at how the virtio
balloon code looked before e22504296d4f64fbbbd741602ab47ee874649c18
you'll see what it should do, eg:

#ifndef CONFIG_BALLOON_COMPACTION
struct balloon_dev_info {
	struct list_head pages;		/* Pages enqueued & handled to Host */
};

static inline struct page *balloon_page_enqueue(struct balloon_dev_info *b_dev_info)
{
        struct page *page = alloc_page(GFP_HIGHUSER | __GFP_NORETRY |
                                       __GFP_NOMEMALLOC | __GFP_NOWARN)
        if (page)
                list_add(&page->lru, &b_dev_info->pages);

        return page;
}

static inline struct page *balloon_page_dequeue(struct balloon_dev_info *b_dev_info)
{
        struct page *page;
        page = list_first_entry(&b_dev_info->pages, struct page, lru);
        list_del(&page->lru);
        return page;
}

static inline void balloon_page_free(struct page *page)
{
        __free_page(page);
}
#else
...

Cheers,
Rusty.
