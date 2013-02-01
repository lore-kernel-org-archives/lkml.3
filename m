Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757178Ab3BARow (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 12:44:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6033 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756373Ab3BARou (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 12:44:50 -0500
Date: Fri, 1 Feb 2013 12:44:43 -0500
From: David Teigland <teigland@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org,
        Christine Caulfield <ccaulfie@redhat.com>, cluster-devel@redhat.com
Subject: Re: [PATCH 10/14] dlm: don't use idr_remove_all()
Message-ID: <20130201174443.GC3812@redhat.com>
References: <1359163872-1949-1-git-send-email-tj@kernel.org>
 <1359163872-1949-11-git-send-email-tj@kernel.org>
 <20130128155723.GC16789@redhat.com>
 <20130129151317.GA11609@redhat.com>
 <20130130212417.GJ24014@redhat.com>
 <20130131235320.GN6824@mtj.dyndns.org>
 <20130201001841.GP6824@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130201001841.GP6824@mtj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2013 at 04:18:41PM -0800, Tejun Heo wrote:
> It looks a bit weird to me that ls->ls_recover_list_count is also
> incremented by recover_list_add().  The two code paths don't seem to
> be interlocke at least upon my very shallow glance.  Is it that only
> either the list or idr is in use?

Yes, that's correct.

> Anyways, can you please apply the following patch and see which IDs
> are leaking from the iteration?  The patch too is only compile tested
> so I might have done something stupid but it hopefully shouldn't be
> too difficult to make it work.

I'm trying your patch now, I don't have a test optimized to hit this code
so it may take a while.

>  static void recover_idr_clear(struct dlm_ls *ls)
>  {
>  	struct dlm_rsb *r;
> @@ -358,7 +364,9 @@ static void recover_idr_clear(struct dlm
>  
>  	spin_lock(&ls->ls_recover_idr_lock);
>  
> +	pr_info("XXX clearing:");
>  	idr_for_each_entry(&ls->ls_recover_idr, r, id) {
> +		pr_cont(" %d", id);

It will often be clearing hundreds of thousands of entries, so this will
probably be excessive.

>  	if (ls->ls_recover_list_count != 0) {
>  		log_error(ls, "warning: recover_list_count %d",
>  			  ls->ls_recover_list_count);
> +		pr_info("XXX leftovers: ");
> +		idr_for_each(&ls->ls_recover_idr, dlm_dump_idr, NULL);
> +		pr_cont("\n");

I already tried my own version of this, but used idr_for_each_entry a
second time.  Unfortunately, the number it found and printed did not match
recover_list_count.

warning: recover_list_count 566

It printed 304 ids:

41218 41222 41223 41224 41226 41228 41229 41230 41231 41232 41234 41235
41236 41237 41239 41241 41242 41243 41244 41245 41246 41249 41252 41253
41254 41255 41256 41257 41259 41260 41261 41263 41264 41266 41271 41272
41273 41274 41277 41278 41475 41480 41483 41524 41525 41526 41655 41731
41741 41745 41749 41767 41768 41769 41772 41773 41782 42113 42114 42115
42121 42122 42124 42128 42132 42136 42138 42139 42141 42165 42375 42381
42385 42388 42390 42392 42399 42401 42404 42407 42409 42411 42416 42422
42694 42699 42712 42717 42727 42866 43009 43042 43044 43046 43049 43051
43058 43059 43064 43065 43066 43067 43330 43332 43337 43338 43339 43343
43348 43349 43351 43354 43355 43356 43361 43362 43368 43369 43370 43375
43376 43377 43378 43379 43381 43575 43576 43577 43677 43678 43680 43683
43684 43685 43689 43690 43819 43820 43823 43824 43825 43826 43827 43828
43829 43831 43905 43907 43908 43912 43929 43930 43955 43956 43960 43962
43965 44288 44289 44291 44296 44298 44300 44310 44311 44313 44314 44316
44318 44321 44323 44325 44454 44456 44457 44458 44544 44547 44548 44550
44555 44557 44560 44562 44564 44567 44573 44575 44576 44578 44579 44581
44582 44583 44584 44585 44589 44592 44595 44596 44726 44728 44729 44732
44734 44866 44867 44873 44876 44878 44879 44912 44914 44916 44920 44923
44924 45053 45186 45189 45190 45195 45197 45199 45200 45201 45203 45204
45208 45209 45212 45213 45216 45220 45223 45224 45225 45227 45228 45231
45234 45440 45441 45444 45448 45450 45452 45454 45456 45457 45458 45459
45460 45461 45464 45466 45467 45472 45475 45477 45484 45485 45488 45492
45494 45495 45496 45497 45498 45499 45628 45630 45698 45699 45700 45703
45707 45708 45710 45713 45715 45717 45720 45722 45723 45724 45725 45727
45729 45730 45731 45733 45734 45737 45739 45741 45742 45746 45748 45750
45755 47292 47293 47294

