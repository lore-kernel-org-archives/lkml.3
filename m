Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930AbaH2R5b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 13:57:31 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:54688 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902AbaH2R5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 13:57:30 -0400
Date: Fri, 29 Aug 2014 20:57:18 +0300
From: Andreea Bernat <bernat.ada@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: shemming@brocade.com, linux-kernel@vger.kernel.org,
        paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH RFC] rcu: assoc_array: Add critical section to avoid a bug
Message-ID: <20140829175718.GA860@ada>
References: <20140826154129.GA4481@ada>
 <3614.1409225551@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3614.1409225551@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2014 at 12:32:31PM +0100, David Howells wrote:
> Andreea-Cristina Bernat <bernat.ada@gmail.com> wrote:
> 
> > * The function "assoc_array_gc()" could be preempted between the call to
> > "assoc_array_apply_edit()" call and the assignment
> > "edit->array->nr_leaves_on_tree = nr_leaves_on_tree;", so the grace
> > period could complete.
> 
> The bug is real, but this patch isn't the right solution.
> 
> The edit script should be considered inaccessible to a function the moment it
> calls assoc_array_apply_edit() or assoc_array_cancel_edit().  I think this is
> a better way.
> 
> David
> ---
>  assoc_array.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> commit 10c26fcc224c0515e15272515e7b9006cb08adc8
> Author: David Howells <dhowells@redhat.com>
> Date:   Wed Aug 27 18:39:44 2014 +0100
> 
>     KEYS: Fix use-after-free in assoc_array_gc()
>     
>     An edit script should be considered inaccessible by a function once it has
>     called assoc_array_apply_edit() or assoc_array_cancel_edit().
>     
>     However, assoc_array_gc() is accessing the edit script just after the
>     gc_complete: label.
>     
>     Reported-by: Andreea-Cristina Bernat <bernat.ada@gmail.com>
>     Signed-off-by: David Howells <dhowells@redhat.com>
> 
> diff --git a/lib/assoc_array.c b/lib/assoc_array.c
> index c0b1007011e1..ae146f0734eb 100644
> --- a/lib/assoc_array.c
> +++ b/lib/assoc_array.c
> @@ -1735,7 +1735,7 @@ ascend_old_tree:
>  gc_complete:
>  	edit->set[0].to = new_root;
>  	assoc_array_apply_edit(edit);
> -	edit->array->nr_leaves_on_tree = nr_leaves_on_tree;
> +	array->nr_leaves_on_tree = nr_leaves_on_tree;
>  	return 0;

Looks good to me.

Regards,
Andreea

>  
>  enomem:
