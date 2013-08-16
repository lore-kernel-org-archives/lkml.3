Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947Ab3HPWOJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:14:09 -0400
Received: from gate.crashing.org ([63.228.1.57]:40134 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751420Ab3HPWOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:14:07 -0400
Message-ID: <1376691186.25016.4.camel@pasglop>
Subject: Re: [RFC PATCH v2 3/4] powerpc: refactor of_get_cpu_node to support
 other architectures
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, devicetree@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, Jonas Bonn <jonas@southpole.se>,
        Michal Simek <monstr@monstr.eu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>
Date: Sat, 17 Aug 2013 08:13:06 +1000
In-Reply-To: <1376674791-28244-2-git-send-email-Sudeep.KarkadaNagesha@arm.com>
References: <1376586580-5409-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
	 <1376674791-28244-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
	 <1376674791-28244-2-git-send-email-Sudeep.KarkadaNagesha@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-08-16 at 18:39 +0100, Sudeep KarkadaNagesha wrote:
> +static bool __of_find_n_match_cpu_property(struct device_node *cpun,
> +                       const char *prop_name, int cpu, unsigned int
> *thread)
> +{
> +       const __be32 *cell;
> +       int ac, prop_len, tid;
> +       u64 hwid;
> +
> +       ac = of_n_addr_cells(cpun);
> +       cell = of_get_property(cpun, prop_name, &prop_len);
> +       if (!cell)
> +               return false;
> +       prop_len /= sizeof(*cell);
> +       for (tid = 0; tid < prop_len; tid++) {
> +               hwid = of_read_number(cell, ac);
> +               if (arch_match_cpu_phys_id(cpu, hwid)) {
> +                       if (thread)
> +                               *thread = tid;
> +                       return true;
> +               }
> +               cell += ac;
> +       }
> +       return false;
> +}

The only problem I can see here is if "ac" is not 1, that will not work
for the ibm,ppc-interrupt-server#s case. IE. The latter is always 1 cell
per entry, only "reg" depends on #address-cells.

However that's only a theorical problem since on ppc #address-cells of
/cpus is always 1...

Cheers,
Ben.


