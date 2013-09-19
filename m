Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708Ab3ISR17 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 13:27:59 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:56078 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797Ab3ISR15 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 13:27:57 -0400
Date: Thu, 19 Sep 2013 19:27:51 +0200
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: Benjamin Poirier <bpoirier@suse.de>
Cc: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>, mmarek@suse.cz,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]kconfig/menu.c: fix uninitialized variable warning
Message-ID: <20130919172751.GA3317@free.fr>
References: <1379575697-6740-1-git-send-email-maddy@linux.vnet.ibm.com>
 <20130919152227.GB19364@d2.synalogic.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20130919152227.GB19364@d2.synalogic.ca>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin, Madhavan, All,

On 2013-09-19 11:22 -0400, Benjamin Poirier spake thusly:
> On 2013/09/19 12:58, Madhavan Srinivasan wrote:
> > In file included from scripts/kconfig/zconf.tab.c:2537:0:
> > scripts/kconfig/menu.c: In function ‘get_symbol_str’:
> > scripts/kconfig/menu.c:586:18: warning: ‘jump’ may be used uninitialized in
> > this function [-Wmaybe-uninitialized]
>                    ^^^^^
> 
> from gcc(1):
> 	"These warnings are made optional because GCC is not smart
> 	enough to see all the reasons why the code might be correct
> 	despite appearing to have an error."
> 
> I do not see this warning with gcc 4.7.2 or 4.8.1. Which version are you
> using?
> 
> The code does:
> 
> static void get_prompt_str(struct gstr *r, struct property *prop,
> [...]
> 	if (head && location) {
> 		jump = xmalloc(sizeof(struct jump_key));
> [... different basic block ...]
> 			if (head && location && menu == location)
> 				jump->offset = r->len - 1;
> 
> If the second "if" is true, then the first one was true as well, and
> "jump" is initilized.

Exactly what I was going to say.

However:
  - I believe we should strive for a warning-free code whenever possible
  - while still getting help from gcc to pinpoint potential issues.

Clearly, gcc is wrong here. Setting jump to NULL will cause fault if we
try to dereference it. Since this should never happen given the code as
it currently is, I'm slightly in favour of acking this patch.

Any other reason not to apply it?

> >      jump->offset = r->len - 1;
> >                   ^
> > scripts/kconfig/menu.c:547:19: note: ‘jump’ was declared here
> >   struct jump_key *jump;
> >                    ^
> > Signed-off-by: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
> > ---
> >  scripts/kconfig/menu.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/scripts/kconfig/menu.c b/scripts/kconfig/menu.c
> > index c1d5320..23b1827 100644
> > --- a/scripts/kconfig/menu.c
> > +++ b/scripts/kconfig/menu.c
> > @@ -544,7 +544,7 @@ static void get_prompt_str(struct gstr *r, struct property *prop,
> >  {
> >  	int i, j;
> >  	struct menu *submenu[8], *menu, *location = NULL;
> > -	struct jump_key *jump;
> > +	struct jump_key *jump = NULL;
> > 
> >  	str_printf(r, _("Prompt: %s\n"), _(prop->text));
> >  	menu = prop->menu->parent;
> > --
> > 1.7.10.4
> > 

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
