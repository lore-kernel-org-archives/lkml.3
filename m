Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404Ab3FQRu1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 13:50:27 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:16463 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936Ab3FQRuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 13:50:23 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 17 Jun 2013 10:50:22 -0700
From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
To: Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-i2c@vger.kernel.org>, Linus Walleij <linus.walleij@linaro.org>,
        Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Subject: [PATCH 0/2] Fix kernel panics with certain I2C tps6* chips
Date: Mon, 17 Jun 2013 20:47:35 +0300
Message-ID: <1371491257-23791-1-git-send-email-ttynkkynen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Latest linux-next head (next-20130617) seems to have some backwards-incompatible
changes to the i2c core, which breaks the tps* drivers in our boards and cause
panics on boot.

ttynkkynen@ttynkkynen-lnx:~/upstream/kernel$ git bisect bad
c80f52847c50109ca248c22efbf71ff10553dca4 is the first bad commit
commit c80f52847c50109ca248c22efbf71ff10553dca4
Author: Linus Walleij <linus.walleij@linaro.org>
Date:   Mon May 13 22:18:21 2013 +0200

    i2c: core: make it possible to match a pure device tree driver
    
    This tries to address an issue found when writing an MFD driver
    for the Nomadik STw481x PMICs: as the platform is using device
    tree exclusively I want to specify the driver matching like
    this:
    
    static const struct of_device_id stw481x_match[] = {
    	{ .compatible = "st,stw4810", },
    	{ .compatible = "st,stw4811", },
    	{},
    };
    
    static struct i2c_driver stw481x_driver = {
    	.driver = {
    		.name	= "stw481x",
    		.of_match_table = stw481x_match,
    	},
    	.probe		= stw481x_probe,
    	.remove		= stw481x_remove,
    };
    
    However that turns out not to be possible: the I2C probe code
    is written so that the probe() call is always passed a match
    from i2c_match_id() using non-devicetree matches.
    
    This is probably why most devices using device tree for I2C
    clients currently will pass no .of_match_table *at all* but
    instead just use .id_table from struct i2c_driver to match
    the device. As you realize that means that the whole idea with
    compatible strings is discarded, and that is why we find strange
    device tree I2C device compatible strings like "product" instead
    of "vendor,product" as you could expect.
    
    Let's figure out how to fix this before the mess spreads. This
    patch will allow probeing devices with only an of_match_table
    as per above, and will pass NULL as the second argument to the
    probe() function. If the driver wants to deduce secondary info
    from the struct of_device_id .data field, it has to call
    of_match_device() on its own match table in the probe function
    device tree probe path.
    
    If drivers define both an .of_match_table *AND* a i2c_driver
    .id_table, the .of_match_table will take precedence, just
    as is done in the i2c_device_match() function in i2c-core.c.
    
    I2C devices probed from device tree should subsequently be
    fixed to handle the case where of_match_table() is
    used (I think none of them do that today), and platforms should
    fix their device trees to use compatible strings for I2C devices
    instead of setting the name to Linux device driver names as is
    done in multiple cases today.
    
    Cc: Rob Herring <rob.herring@calxeda.com>
    Cc: Grant Likely <grant.likely@linaro.org>
    Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
    Signed-off-by: Wolfram Sang <wsa@the-dreams.de>

Tuomas Tynkkynen (2):
  mfd: tps65910: Fix crash in i2c_driver .probe
  regulator: tps62360: Fix crash in i2c_driver .probe

 drivers/mfd/tps65910.c                 | 6 ++++--
 drivers/regulator/tps62360-regulator.c | 8 ++++++--
 2 files changed, 10 insertions(+), 4 deletions(-)

-- 
1.8.1.5

