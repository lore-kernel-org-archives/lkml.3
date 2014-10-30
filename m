Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422667AbaJ3XAQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 19:00:16 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:40171 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161019AbaJ3XAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 19:00:14 -0400
From: Gilad Avidov <gavidov@codeaurora.org>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        grant.likely@linaro.org
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        sdharia@codeaurora.org, linux-arm-msm@vger.kernel.org,
        Gilad Avidov <gavidov@codeaurora.org>
Subject: =?UTF-8?q?=5BPATCH=200/1=5D=20Compact=20interface=20for=20Device-Tree?=
Date: Thu, 30 Oct 2014 16:59:23 -0600
Message-Id: <1414709964-27284-1-git-send-email-gavidov@codeaurora.org>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Device-Tree compact API
------------------------

Common code seen in driver’s probe reads device tree values and handling
erroneous return codes from all those of_property_read_xxx()  APIs. This
common code is factored out by the of_property_map module which allows
driver’s probe to replace that (often lengthy) code with a concise table:

struct of_prop_map map[] = {
    {"i2c",            &dev->id,        OF_REQ,  OF_ID,  -1},
    {"qcom,clk-freq-out",    &dev->clk_freq_out,    OF_REQ,  OF_U32,  0},
    {"qcom,clk-freq-in",    &dev->clk_freq_in,    OF_REQ,  OF_U32,  0},
    {"qcom,disable-dma",    &dev->disable_dma,    OF_OPT,  OF_BOOL, 0},
    {"qcom,master-id",    &dev->mstr_id,        OF_SGST, OF_U32,  0},
    {NULL,            NULL,            0,       0,       0},
};

Then call populate to read the values into the device’s variables:

ret = of_prop_populate(dev, dev->of_node, map);


An equivalent code snippet using the traditional of_property_read_XXXX()
API. Note that the equivalent is longer and more difficult to follow and
debug:

/* optional property */
dev->disable_dma = of_property_read_bool(node, "qcom,disable-dma");

ret = of_property_read_u32(dev->node, "qcom,clk-freq-out", &dev->clk_freq_out);
if (ret) {
    dev_err(dev, "error: missing 'qcom,clk-freq-out' DT property\n");
    if (!err)
        err = ret;
}

ret = of_property_read_u32(dev->node, "qcom,clk-freq-in", &dev->clk_freq_in);
if (ret) {
    dev_err(dev, "error: missing 'qcom,clk-freq-in' DT property\n");
    if (!err)
        err = ret;
}

/* suggested property */
ret = of_property_read_u32(dev->node, "qcom,master-id", &dev->mstr_id);
if (ret && !err)
    err = ret;


ret = of_alias_get_id(dev->node, "i2c");
if (ret < 0) {
    dev_err(dev, "error: missing '"i2c"' DT property\n");
    if (!err)
        err = ret;
} else {
    dev->id = ret;
}


The Device-Tree node and alias which are read by the above code snippets:

aliases {
    i2c0 = &i2c_0; /* I2C0 controller device */
};

i2c_0: i2c@78b6000 { /* BLSP1 QUP2 */
    compatible = "qcom,i2c-msm-v2";
    reg-names = "qup_phys_addr", "bam_phys_addr";
    reg = <0x78b6000 0x600>,
          <0x7884000 0x23000>;
    qcom,clk-freq-out = <100000>;
    qcom,clk-freq-in  = <19200000>;
    qcom,disable-dma;
    qcom,master-id = <86>;
}; 


Gilad Avidov (1):
  of_propery_map: compact interface for Device-Tree

 Documentation/devicetree/of_property_map.txt |   76 ++++++++++++++++++++++
 drivers/of/Makefile                          |    2 +-
 drivers/of/of_property_map.c                 |   88 ++++++++++++++++++++++++++
 include/linux/of_property_map.h              |   74 ++++++++++++++++++++++
 4 files changed, 239 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/of_property_map.txt
 create mode 100644 drivers/of/of_property_map.c
 create mode 100644 include/linux/of_property_map.h

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

