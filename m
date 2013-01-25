Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108Ab3AYKI3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 05:08:29 -0500
Received: from mail-lb0-f169.google.com ([209.85.217.169]:51972 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754935Ab3AYKI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 05:08:27 -0500
MIME-Version: 1.0
X-Originating-IP: [87.194.181.195]
In-Reply-To: <20130125010112.GF2373@mtj.dyndns.org>
References: <20130119003923.GH24579@htj.dyndns.org>
	<20130119004100.GL24579@htj.dyndns.org>
	<20130125001345.GA1960@balrog>
	<20130125010112.GF2373@mtj.dyndns.org>
Date: Fri, 25 Jan 2013 10:08:24 +0000
Message-ID: <CAAG0J9-JQswfnEaqrKPor71DO8dn=qW4Ba6tni0sdwn9OYWL9w@mail.gmail.com>
Subject: Re: [PATCH 4/4] async: replace list of active domains with global
 list of pending items
From: James Hogan <james@albanarts.com>
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>, Dan Williams <djbw@fb.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 January 2013 01:01, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> On Fri, Jan 25, 2013 at 12:13:45AM +0000, James Hogan wrote:
>> Should it have this?
>> +     else
>> +             INIT_LIST_HEAD(&entry->global_list)
>
> I think it would be better to have INIT_LIST_HEAD() during @entry
> initialization.  Heh, I forgot that.  I wonder why it didn't crash on
> my machine.  Can you please cook up a patch to init both list fields
> right after kzalloc()?

How does the following patch look? Feel free to squash it into the
original to avoid breaking bisection :).

Cheers
James


From: James Hogan <james.hogan@imgtec.com>
Date: Fri, 25 Jan 2013 09:46:58 +0000
Subject: [PATCH 1/1] async: initialise list heads to fix crash

The commit "async: replace list of active domains with global list of
pending items" added a struct list_head global_list in struct
async_entry, which isn't initialised. This means that if
!domain->registered at __async_schedule(), then list_del_init() will be
called on the list head in async_run_entry_fn with both pointers NULL,
causing a crash. This is fixed by initialising both the global_list and
domain_list list_heads after kzalloc'ing the entry.

This was noticed due to dapm_power_widgets() which uses
ASYNC_DOMAIN_EXCLUSIVE, which initialises the domain->registered to 0.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 kernel/async.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/async.c b/kernel/async.c
index 6958000..8ddee2c 100644
--- a/kernel/async.c
+++ b/kernel/async.c
@@ -172,6 +172,8 @@ static async_cookie_t
__async_schedule(async_func_ptr *ptr, void *data, struct a
 		ptr(data, newcookie);
 		return newcookie;
 	}
+	INIT_LIST_HEAD(&entry->domain_list);
+	INIT_LIST_HEAD(&entry->global_list);
 	INIT_WORK(&entry->work, async_run_entry_fn);
 	entry->func = ptr;
 	entry->data = data;
-- 
1.7.7.6
