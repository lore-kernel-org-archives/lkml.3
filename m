Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851Ab3CEKxN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 05:53:13 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54113 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469Ab3CEKxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 05:53:12 -0500
Date: Tue, 5 Mar 2013 10:52:51 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: rjw@sisk.pl, Steve.Bannister@arm.com, linux-pm@vger.kernel.org,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>,
        Liviu.Dudau@arm.com, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, robin.randhawa@arm.com,
        linux-arm-kernel@lists.infradead.org, mark.hambleton@broadcom.com,
        linaro-kernel@lists.linaro.org, charles.garcia-tobin@arm.com
Subject: Re: [PATCH] cpufreq: ARM big LITTLE: Add generic cpufreq driver
	and its DT glue
Message-ID: <20130305105251.GL17833@n2100.arm.linux.org.uk>
References: <f20e3c5e822c4bd28a3b71264d73143cc1f850b0.1362458878.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f20e3c5e822c4bd28a3b71264d73143cc1f850b0.1362458878.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 05, 2013 at 12:52:41PM +0800, Viresh Kumar wrote:
> +static void put_cluster_clk_and_freq_table(u32 cluster)
> +{
> +	if (!atomic_dec_return(&cluster_usage[cluster])) {
> +		clk_put(clk[cluster]);
> +		clk[cluster] = NULL;

What's the point in setting the clk to NULL?

> +static int get_cluster_clk_and_freq_table(u32 cluster)
> +{
> +	char name[9] = "cluster";
> +	int count;
> +
> +	if (atomic_inc_return(&cluster_usage[cluster]) != 1)
> +		return 0;
> +
> +	freq_table[cluster] = arm_bL_ops->get_freq_tbl(cluster, &count);
> +	if (!freq_table[cluster])
> +		goto atomic_dec;
> +
> +	name[7] = cluster + '0';
> +	clk[cluster] = clk_get(NULL, name);
> +	if (!IS_ERR_OR_NULL(clk[cluster])) {

NAK.  Two reasons.

1. IS_ERR_OR_NULL.  You know about this, it's been on the list several
   times.

2. Maybe clk_get_sys() rather than clk_get() and use a sensible device
   name ("cpu-cluster.%u" maybe) rather than a connection name with a
   NULL device?
