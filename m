Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932209AbaFIUYt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 16:24:49 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:40417 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbaFIUYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 16:24:45 -0400
Date: Mon, 9 Jun 2014 13:24:43 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrzej Zaborowski <andrew.zaborowski@intel.com>,
        Matt Fleming <matt.fleming@intel.com>
cc: Madper Xie <cxie@redhat.com>, Anton Vorontsov <anton@enomsg.org>,
        Colin Cross <ccross@android.com>, Kees Cook <keescook@chromium.org>,
        Tony Luck <tony.luck@intel.com>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pstore: Fix an overflow on 32-bit builds.
In-Reply-To: <1402325440-26335-1-git-send-email-andrew.zaborowski@intel.com>
Message-ID: <alpine.DEB.2.02.1406091322050.30620@chino.kir.corp.google.com>
References: <1402325440-26335-1-git-send-email-andrew.zaborowski@intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jun 2014, Andrzej Zaborowski wrote:

> [resend]
> In generic_id the long int timestamp is multiplied by 100000 and needs
> an explicit cast to u64.
> 
> Without that the id in the resulting pstore filename is wrong and
> userspace may have problems parsing it, but more importantly files in
> pstore can never be deleted and may fill the EFI flash (brick device?).
> This happens because when generic pstore code wants to delete a file,
> it passes the id to the EFI backend which reinterpretes it and a wrong
> variable name is attempted to be deleted.  There's no error message but
> after remounting pstore, deleted files would reappear.
> 
> Signed-off-by: Andrew Zaborowski <andrew.zaborowski@intel.com>

Acked-by: David Rientjes <rientjes@google.com>

> ---
>  drivers/firmware/efi/efi-pstore.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/firmware/efi/efi-pstore.c b/drivers/firmware/efi/efi-pstore.c
> index 4b9dc83..e992abc 100644
> --- a/drivers/firmware/efi/efi-pstore.c
> +++ b/drivers/firmware/efi/efi-pstore.c
> @@ -40,7 +40,7 @@ struct pstore_read_data {
>  static inline u64 generic_id(unsigned long timestamp,
>  			     unsigned int part, int count)
>  {
> -	return (timestamp * 100 + part) * 1000 + count;
> +	return ((u64) timestamp * 100 + part) * 1000 + count;
>  }
>  
>  static int efi_pstore_read_func(struct efivar_entry *entry, void *data)

This fixes commit fdeadb43fdf1 ("efi-pstore: Make efi-pstore return a 
unique id") that went into stable, so I'm not sure if this should go into 
stable as well.

You probably had to resend this because you didn't email any of the 
maintainers (fixed).  Use scripts/get_maintainer.pl to figure out who to 
email about a patch.
