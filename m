Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706Ab3IRUlT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 16:41:19 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:51054 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812Ab3IRUlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 16:41:17 -0400
MIME-Version: 1.0
X-Originating-IP: [64.196.191.133]
In-Reply-To: <1379535836-12726-1-git-send-email-swarren@wwwdotorg.org>
References: <1379535836-12726-1-git-send-email-swarren@wwwdotorg.org>
Date: Wed, 18 Sep 2013 13:41:16 -0700
Message-ID: <CAOesGMg0Rrmew0iK-Gtrx_UiODhpro_S2xUxQi0gZ+7PJmBHnw@mail.gmail.com>
Subject: Re: [dtc RFC PATCH] Enforce node name unit-address presence/absence
From: Olof Johansson <olof@lixom.net>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Jon Loeliger <jdl@jdl.com>, David Gibson <david@gibson.dropbear.id.au>,
        Frank Rowand <frowand.list@gmail.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Stephen Warren <swarren@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 18, 2013 at 1:23 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> From: Stephen Warren <swarren@nvidia.com>
>
> ePAPR 1.1 section 2.2.1.1 "Node Name Requirements" specifies that any
> node that has a reg property must include a unit address in its name
> with value matching the first entry in its reg property. Conversely, if
> a node does not have a reg property, the node name must not include a
> unit address.
>
> Implement a check for this. The code doesn't validate the format of the
> unit address; ePAPR implies this may vary from binding to binding, so
> I'm not sure that it's possible to validate the value itself.
>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---
> This depends on my previous patch "Ensure all tests have matching reg
> and unit address".
>
> Note that this patch should not yet be applied; it will cause many real-
> world *.dts files to fail to compile. Those need to be fixed first.
> However, if/when that happens, this patch may be useful.
> ---
>  checks.c | 18 +++++++++++++++++-
>  1 file changed, 17 insertions(+), 1 deletion(-)
>
> diff --git a/checks.c b/checks.c
> index ee96a25..c80a055 100644
> --- a/checks.c
> +++ b/checks.c
> @@ -287,9 +287,25 @@ NODE_ERROR(node_name_chars, PROPNODECHARS "@");
>  static void check_node_name_format(struct check *c, struct node *dt,
>                                    struct node *node)
>  {
> -       if (strchr(get_unitname(node), '@'))
> +       const char *unitname;
> +       struct property *prop;
> +
> +       unitname = get_unitname(node);
> +
> +       if (strchr(unitname, '@'))
>                 FAIL(c, "Node %s has multiple '@' characters in name",
>                      node->fullpath);
> +
> +       prop = get_property(node, "reg");
> +       if (prop) {
> +               if (!unitname[0])
> +                       FAIL(c, "Node %s has a reg property, but no unit name",
> +                           node->fullpath);
> +       } else {
> +               if (unitname[0])
> +                       FAIL(c, "Node %s has a unit name, but no reg property",
> +                           node->fullpath);

These checks are very useful, even though they might sort of cross
over the domain to what a dtc linter would do instead of the compiler.

Anyway, I think it'd be better to produce warnings than errors for
this. That way we could also merge it now while the trees are fixed
up.

Also, maybe warn for @0x<foo>, which is another unpreferred syntax, it
should just be @<foo> (with foo being in hex).


-Olof
