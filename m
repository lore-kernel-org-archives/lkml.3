Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753005Ab3H0IfZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 04:35:25 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:57426 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305Ab3H0IfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 04:35:20 -0400
Subject: Re: [PATCH 13/18] Hibernate: Avoid S4 sign key data included in
 snapshot image
From: joeyli <jlee@suse.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-crypto@vger.kernel.org, opensuse-kernel@opensuse.org,
        David Howells <dhowells@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Len Brown <len.brown@intel.com>,
        Josh Boyer <jwboyer@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>,
        Matt Fleming <matt.fleming@intel.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Greg KH <gregkh@linuxfoundation.org>, JKosina@suse.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        Gary Lin <GLin@suse.com>, Vivek Goyal <vgoyal@redhat.com>
In-Reply-To: <20130825163931.GJ5171@amd.pavel.ucw.cz>
References: <1377169317-5959-1-git-send-email-jlee@suse.com>
	 <1377169317-5959-14-git-send-email-jlee@suse.com>
	 <20130825163931.GJ5171@amd.pavel.ucw.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Aug 2013 16:33:52 +0800
Message-ID: <1377592432.27967.80.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 日，2013-08-25 於 18:39 +0200，Pavel Machek 提到：
> On Thu 2013-08-22 19:01:52, Lee, Chun-Yi wrote:
> > This patch add swsusp_page_is_sign_key() method to hibernate_key.c and
> > check the page is S4 sign key data when collect saveable page in
> > snapshot.c to avoid sign key data included in snapshot image.
> > 
> > Reviewed-by: Jiri Kosina <jkosina@suse.cz>
> > Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
> > ---
> >  kernel/power/snapshot.c |    6 ++++++
> >  1 files changed, 6 insertions(+), 0 deletions(-)
> > 
> > diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
> > index 72e2911..9e4c94b 100644
> > --- a/kernel/power/snapshot.c
> > +++ b/kernel/power/snapshot.c
> > @@ -860,6 +860,9 @@ static struct page *saveable_highmem_page(struct zone *zone, unsigned long pfn)
> >  
> >  	BUG_ON(!PageHighMem(page));
> >  
> > +	if (swsusp_page_is_sign_key(page))
> > +		return NULL;
> > +
> >  	if (swsusp_page_is_forbidden(page) ||  swsusp_page_is_free(page) ||
> >  	    PageReserved(page))
> >  		return NULL;
> 
> Just do set_page_forbidden() on your page?

Before call swsusp_unset_page_forbidden(), we need make sure the
create_basic_memory_bitmaps() function already called to initial
forbidden_pages_map. That means need careful the timing, otherwise the
page of private key will not register to forbidden pages map.

So, I choice to refuse the page of private key when snapshot finding
which page is saveable. It has clearer code and we don't need worry the
future change of hibernate.c or user.c for when they call
create_basic_memory_bitmaps() and when the code clear forbidden pages
map.


Thanks a lot!
Joey Lee


