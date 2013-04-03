Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759656Ab3DCN7u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 09:59:50 -0400
Received: from a9-54.smtp-out.amazonses.com ([54.240.9.54]:37493 "EHLO
	a9-54.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757690Ab3DCN7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 09:59:49 -0400
X-Greylist: delayed 361 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Apr 2013 09:59:48 EDT
Date: Wed, 3 Apr 2013 13:53:45 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Hugh Dickins <hughd@google.com>
cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hillf Danton <dhillf@gmail.com>, Ying Han <yinghan@google.com>,
        Minchan Kim <minchan@kernel.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: RE: [PATCHv2, RFC 20/30] ramfs: enable transparent huge page cache
In-Reply-To: <alpine.LNX.2.00.1304021422460.19363@eggly.anvils>
Message-ID: <0000013dd02cbd43-c64cd198-7c04-4dfa-acdc-e725c776fed7-000000@email.amazonses.com>
References: <1363283435-7666-1-git-send-email-kirill.shutemov@linux.intel.com> <1363283435-7666-21-git-send-email-kirill.shutemov@linux.intel.com> <20130402162813.0B4CBE0085@blue.fi.intel.com> <alpine.LNX.2.00.1304021422460.19363@eggly.anvils>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.04.03-54.240.9.54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Apr 2013, Hugh Dickins wrote:

> I am strongly in favour of removing that limitation from
> __isolate_lru_page() (and the thread you pointed - thank you - shows Mel
> and Christoph were both in favour too); and note that there is no such
> restriction in the confusingly similar but different isolate_lru_page().

Well the naming could be cleaned up. The fundamental issue with migrating
pages is that all references have to be tracked and updates in a way that
no references can be followed to invalid or stale page contents. If ramfs
does not maintain separate pointers but only relies on pointers already
handled by the migration logic then migration is fine.

> Some people do worry that migrating Mlocked pages would introduce the
> occasional possibility of a minor fault (with migration_entry_wait())
> on an Mlocked region which never faulted before.  I tend to dismiss
> that worry, but maybe I'm wrong to do so: maybe there should be a
> tunable for realtimey people to set, to prohibit page migration from
> mlocked areas; but the default should be to allow it.

Could we have a different way of marking pages "pinned"? This is useful
for various subsystems (like RDMA and various graphics drivers etc) which
need to ensure that virtual address to physical address mappings stay the
same for a prolonged period of time. I think this use case is becoming
more frequent given that offload techniques have to be used these days to
overcome the limits on processor performance.

> The other reason it looks as if ramfs pages cannot be migrated, is
> that it does not set a suitable ->migratepage method, so would be
> handled by fallback_migrate_page(), whose PageDirty test will end
> up failing the migration with -EBUSY or -EINVAL - if I read it
> correctly.

These could be handled the same way that anonymous pages are handled.

> But until ramfs pages can be migrated, they should not be allocated
> with __GFP_MOVABLE.  (I've been writing about the migratability of
> small pages: I expect you have the migratability of THPages in flux.)

I agree.

