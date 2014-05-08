Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549AbaEHJBU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 05:01:20 -0400
Received: from mail-ig0-f173.google.com ([209.85.213.173]:38520 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164AbaEHJBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 05:01:18 -0400
MIME-Version: 1.0
In-Reply-To: <1399499298-8830-2-git-send-email-robherring2@gmail.com>
References: <1399499298-8830-1-git-send-email-robherring2@gmail.com> <1399499298-8830-2-git-send-email-robherring2@gmail.com>
From: Grant Likely <grant.likely@linaro.org>
Date: Thu, 8 May 2014 10:00:57 +0100
X-Google-Sender-Auth: 51eV5toSwFb9GAekxQeUrIQLlSo
Message-ID: <CACxGe6sWJwjPnbNYK9Uew8dXrFRukwFUB0PAKqX1sdc4udYUYw@mail.gmail.com>
Subject: Re: [PATCH 1/4] of/selftest: add testcase for nodes with same name
 and address
To: Rob Herring <robherring2@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Josh Cartwright <joshc@codeaurora.org>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Bjorn Andersson <bjorn@kryo.se>, Frank Rowand <frowand.list@gmail.com>,
        Rob Herring <robh@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 7, 2014 at 10:48 PM, Rob Herring <robherring2@gmail.com> wrote:
> From: Rob Herring <robh@kernel.org>
>
> Add a test case for nodes which have the same name and same
> non-translatable unit address.
>
> Signed-off-by: Rob Herring <robh@kernel.org>

Looks good to me.

Reviewed-by: Grant Likely <grant.likely@linaro.org>

> ---
>  drivers/of/selftest.c                        | 23 ++++++++++++++++++
>  drivers/of/testcase-data/testcases.dtsi      |  1 +
>  drivers/of/testcase-data/tests-platform.dtsi | 35 ++++++++++++++++++++++++++++
>  3 files changed, 59 insertions(+)
>  create mode 100644 drivers/of/testcase-data/tests-platform.dtsi
>
> diff --git a/drivers/of/selftest.c b/drivers/of/selftest.c
> index ae44500..c93cb4a 100644
> --- a/drivers/of/selftest.c
> +++ b/drivers/of/selftest.c
> @@ -10,6 +10,7 @@
>  #include <linux/module.h>
>  #include <linux/of.h>
>  #include <linux/of_irq.h>
> +#include <linux/of_platform.h>
>  #include <linux/list.h>
>  #include <linux/mutex.h>
>  #include <linux/slab.h>
> @@ -427,6 +428,27 @@ static void __init of_selftest_match_node(void)
>         }
>  }
>
> +static void __init of_selftest_platform_populate(void)
> +{
> +       struct device_node *np, *child;
> +       int rc;
> +       struct of_device_id match[] = {
> +               { .compatible = "test-device", },
> +               {}
> +       };
> +
> +       np = of_find_node_by_path("/testcase-data/platform-tests");
> +       if (!np) {
> +               pr_err("No testcase data in device tree\n");
> +               return;
> +       }
> +
> +       for_each_child_of_node(np, child) {
> +               rc = of_platform_populate(child, match, NULL, NULL);
> +               selftest(!rc, "Could not create device for node '%s'\n", child->name);
> +       }
> +}
> +
>  static int __init of_selftest(void)
>  {
>         struct device_node *np;
> @@ -445,6 +467,7 @@ static int __init of_selftest(void)
>         of_selftest_parse_interrupts();
>         of_selftest_parse_interrupts_extended();
>         of_selftest_match_node();
> +       of_selftest_platform_populate();
>         pr_info("end of selftest - %i passed, %i failed\n",
>                 selftest_results.passed, selftest_results.failed);
>         return 0;
> diff --git a/drivers/of/testcase-data/testcases.dtsi b/drivers/of/testcase-data/testcases.dtsi
> index 3a5b75a..6d8d980a 100644
> --- a/drivers/of/testcase-data/testcases.dtsi
> +++ b/drivers/of/testcase-data/testcases.dtsi
> @@ -1,3 +1,4 @@
>  #include "tests-phandle.dtsi"
>  #include "tests-interrupts.dtsi"
>  #include "tests-match.dtsi"
> +#include "tests-platform.dtsi"
> diff --git a/drivers/of/testcase-data/tests-platform.dtsi b/drivers/of/testcase-data/tests-platform.dtsi
> new file mode 100644
> index 0000000..eb20eeb
> --- /dev/null
> +++ b/drivers/of/testcase-data/tests-platform.dtsi
> @@ -0,0 +1,35 @@
> +
> +/ {
> +       testcase-data {
> +               platform-tests {
> +                       #address-cells = <1>;
> +                       #size-cells = <0>;
> +
> +                       test-device@0 {
> +                               compatible = "test-device";
> +                               reg = <0x0>;
> +
> +                               #address-cells = <1>;
> +                               #size-cells = <0>;
> +
> +                               dev@100 {
> +                                       compatible = "test-sub-device";
> +                                       reg = <0x100>;
> +                               };
> +                       };
> +
> +                       test-device@1 {
> +                               compatible = "test-device";
> +                               reg = <0x1>;
> +
> +                               #address-cells = <1>;
> +                               #size-cells = <0>;
> +
> +                               dev@100 {
> +                                       compatible = "test-sub-device";
> +                                       reg = <0x100>;
> +                               };
> +                       };
> +               };
> +       };
> +};
> --
> 1.9.1
>
