Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748Ab3H0DX6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 23:23:58 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:36705 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048Ab3H0DX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 23:23:56 -0400
Subject: Re: [PATCH 12/18] Hibernate: generate and verify signature of
 snapshot
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
In-Reply-To: <20130825163648.GI5171@amd.pavel.ucw.cz>
References: <1377169317-5959-1-git-send-email-jlee@suse.com>
	 <1377169317-5959-13-git-send-email-jlee@suse.com>
	 <20130825163648.GI5171@amd.pavel.ucw.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Aug 2013 11:22:28 +0800
Message-ID: <1377573748.27967.60.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel, 

Thanks for your time to review my patches.

於 日，2013-08-25 於 18:36 +0200，Pavel Machek 提到：
> On Thu 2013-08-22 19:01:51, Lee, Chun-Yi wrote:
> > This patch add the code for generate/verify signature of snapshot, it
> > put the signature to snapshot header. This approach can support both
> > on userspace hibernate and in-kernel hibernate.
> > 
> > v2:
> > - Due to loaded S4 sign key before ExitBootServices, we need forward key from
> >   boot kernel to resume target kernel. So this patch add a empty page in
> >   snapshot image, then we keep the pfn of this empty page in snapshot header.
> >   When system resume from hibernate, we fill new sign key to this empty page
> >   space after snapshot image checked pass. This mechanism let boot kernel can
> >   forward new sign key to resume target kernel but don't need write new private
> >   key to any other storage, e.g. swap.
> > 
> > Cc: Matthew Garrett <mjg59@srcf.ucam.org>
> > Reviewed-by: Jiri Kosina <jkosina@suse.cz>
> > Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
> > ---
> >  kernel/power/power.h    |    6 +
> >  kernel/power/snapshot.c |  280 +++++++++++++++++++++++++++++++++++++++++++++-
> >  kernel/power/swap.c     |   14 +++
> >  kernel/power/user.c     |    9 ++
> >  4 files changed, 302 insertions(+), 7 deletions(-)
> > 
> > diff --git a/kernel/power/power.h b/kernel/power/power.h
> > index 69a81d8..84e0b06 100644
> > --- a/kernel/power/power.h
> > +++ b/kernel/power/power.h
> > @@ -3,6 +3,9 @@
> >  #include <linux/utsname.h>
> >  #include <linux/freezer.h>
> >  
> > +/* The maximum length of snapshot signature */
> > +#define SIG_LENG 512
> > +
> >  struct swsusp_info {
> >  	struct new_utsname	uts;
> >  	u32			version_code;
> > @@ -11,6 +14,8 @@ struct swsusp_info {
> >  	unsigned long		image_pages;
> >  	unsigned long		pages;
> >  	unsigned long		size;
> > +	unsigned long           skey_data_buf_pfn;
> > +	u8			signature[SIG_LENG];
> >  } __attribute__((aligned(PAGE_SIZE)));
> 
> SIG_LEN or SIG_LENGTH. Select one.
> 

I will use SIG_LEN at next version, thanks!

> 
> > +static int
> >  copy_data_pages(struct memory_bitmap *copy_bm, struct memory_bitmap *orig_bm)
> >  {
> >  	struct zone *zone;
> > -	unsigned long pfn;
> > +	unsigned long pfn, dst_pfn;
> ...
> > +	tfm = crypto_alloc_shash(SNAPSHOT_HASH, 0, 0);
> > +	if (IS_ERR(tfm)) {
> > +		pr_err("IS_ERR(tfm): %ld", PTR_ERR(tfm));
> > +		return PTR_ERR(tfm);
> > +	}
> > +
> > +	desc_size = crypto_shash_descsize(tfm) + sizeof(*desc);
> > +	digest_size = crypto_shash_digestsize(tfm);
> > +	digest = kzalloc(digest_size + desc_size, GFP_KERNEL);
> 
> Are you sure GFP_KERNEL allocation is okay at this phase of
> hibernation?
> 
> Could the hashing be done at later phase, when writing the image to
> disk?
> 

Thanks for you point out!

Yes, call memory allocate here is not a good design due to it causes
garbage in snapshot that will not released by resumed kernel.

I just finished another implementation, the respin patch extracts the
signature generation code to another function then call the function in
swsusp_save() after copy_data_pages() finished. We can write to memory
at that stage.

> >  
> > +void **h_buf;
> 
> helpfully named.
> 

I will change the name to handle_buffers;

> > +	ret = verify_signature(s4_wake_key, pks);
> > +	if (ret) {
> > +		pr_err("snapshot S4 signature verification fail: %d\n", ret);
> > +		goto error_verify;
> > +	} else
> > +		pr_info("snapshot S4 signature verification pass!\n");
> > +
> > +	if (pks->rsa.s)
> > +		mpi_free(pks->rsa.s);
> > +	kfree(pks);
> 
> ret = 0 and fall through?
> 

When verification success, verify_signature() will return 0.

Yes, here have duplicate code, I will clear up it.

> > +	return 0;
> > +
> > +error_verify:
> > +	if (pks->rsa.s)
> > +		mpi_free(pks->rsa.s);
> > +error_mpi:
> > +	kfree(pks);
> > +	return ret;
> > +}
> 
> 
> > +	ret = crypto_shash_final(desc, digest);
> > +	if (ret)
> > +		goto error_shash;
> > +
> > +	ret = snapshot_verify_signature(digest, digest_size);
> > +	if (ret)
> > +		goto error_verify;
> > +
> > +	kfree(h_buf);
> > +	kfree(digest);
> > +	crypto_free_shash(tfm);
> > +	return 0;
> 
> These four lines can be deleted.
> 

Yes, here also duplicate, I will remove.

> > +
> > +error_verify:
> > +error_shash:
> > +	kfree(h_buf);
> > +	kfree(digest);
> > +error_digest:
> > +	crypto_free_shash(tfm);
> > +	return ret;
> > +}
> > +
> 									Pavel


Thanks a lot!
Joey Lee

