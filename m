Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933547Ab3CVOni (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 10:43:38 -0400
Received: from www.sr71.net ([198.145.64.142]:60297 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932643Ab3CVOng (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 10:43:36 -0400
Message-ID: <514C6E68.4050203@sr71.net>
Date: Fri, 22 Mar 2013 07:44:56 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
CC: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hillf Danton <dhillf@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2, RFC 07/30] thp, mm: introduce mapping_can_have_hugepages()
 predicate
References: <1363283435-7666-1-git-send-email-kirill.shutemov@linux.intel.com> <1363283435-7666-8-git-send-email-kirill.shutemov@linux.intel.com> <514B336C.6070404@sr71.net> <20130322101211.34A5EE0085@blue.fi.intel.com>
In-Reply-To: <20130322101211.34A5EE0085@blue.fi.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2013 03:12 AM, Kirill A. Shutemov wrote:
> Dave Hansen wrote:
>> On 03/14/2013 10:50 AM, Kirill A. Shutemov wrote:
>>> +static inline bool mapping_can_have_hugepages(struct address_space *m)
>>> +{
>>> +	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
>>> +		gfp_t gfp_mask = mapping_gfp_mask(m);
>>> +		return !!(gfp_mask & __GFP_COMP);
>>> +	}
>>> +
>>> +	return false;
>>> +}
>>
>> I did a quick search in all your patches and don't see __GFP_COMP
>> getting _set_ anywhere.  Am I missing something?
> 
> __GFP_COMP is part of GFP_TRANSHUGE. We set it for ramfs in patch 20/30.

That's a bit non-obvious.  For a casual observer, it _seems_ like you
should just be setting and checking GFP_TRANSHUGE directly.  It looks
like you were having some problems with __GFP_MOVABLE and masked it out
of GFP_TRANSHUGE and that has cascaded over to _this_ check.

I _think_ the right thing to do is add a comment up there in
mapping_can_have_hugepages() that does (GFP_TRANSHUGE & ~__GFP_MOVABLE),
and adds a TODO in the code and patch comments to clean it up once
ramfs_get_inode() gets fixed up too.
