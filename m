Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309Ab3ISPWe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 11:22:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60470 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751157Ab3ISPWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 11:22:33 -0400
Date: Thu, 19 Sep 2013 11:22:27 -0400
From: Benjamin Poirier <bpoirier@suse.de>
To: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
Cc: mmarek@suse.cz, yann.morin.1998@free.fr, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH]kconfig/menu.c: fix uninitialized variable warning
Message-ID: <20130919152227.GB19364@d2.synalogic.ca>
References: <1379575697-6740-1-git-send-email-maddy@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1379575697-6740-1-git-send-email-maddy@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/09/19 12:58, Madhavan Srinivasan wrote:
> In file included from scripts/kconfig/zconf.tab.c:2537:0:
> scripts/kconfig/menu.c: In function ‘get_symbol_str’:
> scripts/kconfig/menu.c:586:18: warning: ‘jump’ may be used uninitialized in
> this function [-Wmaybe-uninitialized]
                   ^^^^^

from gcc(1):
	"These warnings are made optional because GCC is not smart
	enough to see all the reasons why the code might be correct
	despite appearing to have an error."

I do not see this warning with gcc 4.7.2 or 4.8.1. Which version are you
using?

The code does:

static void get_prompt_str(struct gstr *r, struct property *prop,
[...]
	if (head && location) {
		jump = xmalloc(sizeof(struct jump_key));
[... different basic block ...]
			if (head && location && menu == location)
				jump->offset = r->len - 1;

If the second "if" is true, then the first one was true as well, and
"jump" is initilized.

>      jump->offset = r->len - 1;
>                   ^
> scripts/kconfig/menu.c:547:19: note: ‘jump’ was declared here
>   struct jump_key *jump;
>                    ^
> Signed-off-by: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
> ---
>  scripts/kconfig/menu.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/scripts/kconfig/menu.c b/scripts/kconfig/menu.c
> index c1d5320..23b1827 100644
> --- a/scripts/kconfig/menu.c
> +++ b/scripts/kconfig/menu.c
> @@ -544,7 +544,7 @@ static void get_prompt_str(struct gstr *r, struct property *prop,
>  {
>  	int i, j;
>  	struct menu *submenu[8], *menu, *location = NULL;
> -	struct jump_key *jump;
> +	struct jump_key *jump = NULL;
> 
>  	str_printf(r, _("Prompt: %s\n"), _(prop->text));
>  	menu = prop->menu->parent;
> --
> 1.7.10.4
> 
