Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130AbaCCSPx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 13:15:53 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:37945 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754083AbaCCSPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 13:15:50 -0500
X-AuditID: cbfee61b-b7f456d000006dfd-9d-5314c6d3859a
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Cc: gregkh@linuxfoundation.org, mturquette@linaro.org, linux@arm.linux.org.uk,
        robh+dt@kernel.org, grant.likely@linaro.org, mark.rutland@arm.com,
        galak@codeaurora.org, kyungmin.park@samsung.com,
        sw0312.kim@samsung.com, m.szyprowski@samsung.com, t.figa@samsung.com,
        linux-kernel@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [RFC PATCH v2 0/2] clk: Support for DT assigned clock parents and rates
Date: Mon, 03 Mar 2014 19:15:31 +0100
Message-id: <1393870533-20845-1-git-send-email-s.nawrocki@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKLMWRmVeSWpSXmKPExsVy+t9jAd3Lx0SCDW7+5LGYf+Qcq0X/m4Ws
	Fgf+7GC0aF68ns3ibNMbdotNj6+xWlzeNYfN4vZlXou1R+6yWyy9fpHJ4umEi2wWrXuPsFsc
	ftPOajFj8ks2i/UzXrM48HusmbeG0aOluYfN43JfL5PHplWdbB53ru1h89g/dw27x+Yl9R59
	W1YxenzeJBfAGcVlk5Kak1mWWqRvl8CVcX5ZP1vBL8GKzp0fmRsY9/J2MXJySAiYSFz538MG
	YYtJXLi3Hsjm4hASWMQo8fLzEnYIp4NJ4tmHbewgVWwChhK9R/sYQWwRAReJzgfrWEBsZoFb
	TBJTTkqB2MICARL3errAalgEVCXW7jsF1ssr4CaxcX0TkM0BtE1BYs4kmwmM3AsYGVYxiqYW
	JBcUJ6XnGukVJ+YWl+al6yXn525iBAfmM+kdjKsaLA4xCnAwKvHwOkwRCRZiTSwrrsw9xCjB
	wawkwhtRAxTiTUmsrEotyo8vKs1JLT7EKM3BoiTOe7DVOlBIID2xJDU7NbUgtQgmy8TBKdXA
	6PGb0U/iY6cvm/3BPY5ucQX7Ly+XW/Q7c4VcXrOIRPl5y9Xe2VKvyq/3b9WwOyxuN0X4XezD
	HpE09f9Sm8Vq3a19P89PqZiu8qvSPCTo0e24Yv+eMuHnj8PsbJtWnDKYcXbZiz/pz3WO66Zd
	XLLi1ZLogmWshQJ/hXxCa+b+OBmncPiow08dJZbijERDLeai4kQAv+hQiEgCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set adds a DT binding documentation for new 'clock-parents'
and 'clock-rates' DT properties and a helper function to parse them.
The helper is now being called from within the driver core, similarly
as it is done for the pins configuration binding to a device.

Patch 1/2 adds a variant of of_clk_get() function which accepts name of
a DT property containing list of phandle + clock specifier pairs, as
opposed to hard coded "clocks" property name in of_clk_get().
As Mike suggested I've renamed this function to of_clk_get_by_property().

Patch 2/2 actually adds the code searching for related DT properties at
device node and performing re-parenting and/or clock frequency setting
as specified.

Changes since v1:
 - updated DT binding documentation,
 - dropped the platform bus notifier, the clock setup routine is now
   being called directly from the driver core before a driver probe() call;
   this has an advantage such as all bus types are handled and any errors
   are propagated, so that, for instance a driver probe() can be deferred
   also when resources specified by clock-parents/clock-rates properties
   are not yet available; an alternative would be to let drivers call
   of_clk_device_setup() directly,
 - dropped the patch adding a macro definition for maximum DT property
   name length for now.

Open issues:
 - handling of errors from of_clk_get_by_property() could be improved,
   currently ENOENT is returned by this function not only for a null
   entry.

This series has been tested on ARM, on Exynos4412 Trats2 board.
RFC v1 can be found at:
http://www.spinics.net/lists/arm-kernel/msg309241.html

Sylwester Nawrocki (2):
  clk: Add function parsing arbitrary clock list DT property
  clk: Add handling of clk parent and rate assigned from DT

 .../devicetree/bindings/clock/clock-bindings.txt   |   23 ++++++
 drivers/base/dd.c                                  |    5 ++
 drivers/clk/clk.c                                  |   77 ++++++++++++++++++++
 drivers/clk/clk.h                                  |    3 +
 drivers/clk/clkdev.c                               |   25 ++++++-
 include/linux/clk-provider.h                       |    6 ++
 6 files changed, 135 insertions(+), 4 deletions(-)

--
1.7.9.5

