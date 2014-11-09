Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751569AbaKISul (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 13:50:41 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:60689 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751365AbaKISuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 13:50:39 -0500
Date: Sun, 9 Nov 2014 18:50:19 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Mark Brown <broonie@kernel.org>, Lars-Peter Clausen <lars@metafoo.de>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] of: Make const the device node pointers in
 of_clk_get and of_node_put
Message-ID: <20141109185019.GU4042@n2100.arm.linux.org.uk>
References: <cover.1415557680.git.moinejf@free.fr>
 <375a82230accf26dfbbb74e6f928243ea8e38b50.1415557680.git.moinejf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <375a82230accf26dfbbb74e6f928243ea8e38b50.1415557680.git.moinejf@free.fr>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 08, 2014 at 07:33:22PM +0100, Jean-Francois Moine wrote:
> Some device nodes are sometimes referenced by const pointers.
> 
> This patch avoids to cast these pointers when calling the functions
> of_clk_get() and of_node_put().

NAK.  Firstly, of_node_put contains a kref, which is /definitely/ not
a const item when kobject_put() is called on it.  Inside the kobject
is a kref, which kobject_put() will call kref_put() on.  kref_put()
in turn will internally call atomic_sub_and_test() on a value embedded
within the kref struct.

Ergo, of_node_put() modifies the struct device_node contents.  Therefore,
of_node_put() definitely not treating the data pointed to as read-only,
and therefore it is completely inappropriate for it to be marked "const".

What this then means is that it fundamentally undermines the idea of
storing the pointer to a device_node as a const pointer, as the device
node must always be modified when you're done with it (because it's a
ref-counted structure.)  So, having it const in your code is a bug.

What this also means is that every other place that you've added const
below is also very dubious.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
