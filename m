Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751825Ab3LKOvp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 09:51:45 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:33320 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568Ab3LKOvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 09:51:42 -0500
MIME-Version: 1.0
In-Reply-To: <1386684833-24112-2-git-send-email-panto@antoniou-consulting.com>
References: <1386684833-24112-1-git-send-email-panto@antoniou-consulting.com> <1386684833-24112-2-git-send-email-panto@antoniou-consulting.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 11 Dec 2013 14:51:19 +0000
X-Google-Sender-Auth: api_fLygMMghj9HAv9Yt_I11xTg
Message-ID: <CACxGe6vYKUCFboQ0iZqQAHcHahzA+AiRfv5nzkQhMzV=-C6UxQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] of: Fix early OF builtup on kobj-ification
To: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Michael Stickel <ms@mycable.de>, Guenter Roeck <linux@roeck-us.net>,
        Dirk Behme <dirk.behme@gmail.com>,
        Alan Tull <delicious.quinoa@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>,
        Ionut Nicu <ioan.nicu.ext@nsn.com>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 2:13 PM, Pantelis Antoniou
<panto@antoniou-consulting.com> wrote:
> When booting platforms that do very early OF initialization before
> core_initcalls are performed of_init is called too late.
>
> This results in a hard-hard without getting a chance to output anything.
>
> Fixed by adding a flag that marks when init has been done, and
> performing the per-node init at that time.
>
> Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
> ---
>  drivers/of/base.c | 28 +++++++++++++++++++++++-----
>  1 file changed, 23 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/of/base.c b/drivers/of/base.c
> index 734689b..a4f3dda 100644
> --- a/drivers/of/base.c
> +++ b/drivers/of/base.c
> @@ -98,7 +98,7 @@ int __weak of_node_to_nid(struct device_node *np)
>   */
>  struct device_node *of_node_get(struct device_node *node)
>  {
> -       if (node)
> +       if (node && of_kset)
>                 kobject_get(&node->kobj);
>         return node;
>  }
> @@ -156,7 +156,7 @@ static void of_node_release(struct kobject *kobj)
>   */
>  void of_node_put(struct device_node *node)
>  {
> -       if (node)
> +       if (node && of_kset)
>                 kobject_put(&node->kobj);
>  }

As discussed on IRC, I don't think this is required.

>  EXPORT_SYMBOL(of_node_put);
> @@ -202,9 +202,16 @@ static const char *safe_name(struct kobject *kobj, const char *orig_name)
>  static int __of_add_property(struct device_node *np, struct property *pp)
>  {
>         int rc;
> +       bool secure;
> +
> +       /* note that we don't take a lock here */
> +
> +       /* fake the return while of_init is not yet called */
> +       if (!of_kset)
> +               return 0;

__of_add_property is called from three functions; __of_node_add(),
of_add_property() and of_modify_property(). __of_node_add is never
called on an unattached node. If the other two are getting called
early, then I think they should make the check. I'll modify my patch
to reflect that.

>
>         /* Important: Don't leak passwords */
> -       bool secure = strncmp(pp->name, "security-", 9) == 0;
> +       secure = strncmp(pp->name, "security-", 9) == 0;
>
>         pp->attr.attr.name = safe_name(&np->kobj, pp->name);
>         pp->attr.attr.mode = secure ? S_IRUSR : S_IRUGO;
> @@ -222,6 +229,12 @@ static int __of_node_add(struct device_node *np)
>         struct property *pp;
>         int rc;
>
> +       /* note that we don't take a lock here */
> +
> +       /* fake the return while of_init is not yet called */
> +       if (!of_kset)
> +               return 0;
> +

__of_node_add() never gets called before of_kset is initialized.

>         np->kobj.kset = of_kset;
>         if (!np->parent) {
>                 /* Nodes without parents are new top level trees */
> @@ -245,11 +258,14 @@ static int __of_node_add(struct device_node *np)
>  int of_node_add(struct device_node *np)
>  {
>         int rc = 0;
> -       kobject_init(&np->kobj, &of_node_ktype);
> +
> +       /* fake the return while of_init is not yet called */
>         mutex_lock(&of_aliases_mutex);
> +       kobject_init(&np->kobj, &of_node_ktype);

Why the kobject_init() move?

>         if (of_kset)
>                 rc = __of_node_add(np);
>         mutex_unlock(&of_aliases_mutex);
> +
>         return rc;
>  }
>
> @@ -275,14 +291,16 @@ static int __init of_init(void)
>
>         /* Make sure all nodes added before this time get added to sysfs */
>         mutex_lock(&of_aliases_mutex);
> +
>         for_each_of_allnodes(np)
>                 __of_node_add(np);
> -       mutex_unlock(&of_aliases_mutex);
>
>         /* Symlink in /proc as required by userspace ABI */
>         if (of_allnodes)
>                 proc_symlink("device-tree", NULL, "/sys/firmware/devicetree/base");
>
> +       mutex_unlock(&of_aliases_mutex);
> +
>         return 0;
>  }
>  core_initcall(of_init);
> --
> 1.7.12
>
