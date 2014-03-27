Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111AbaC0MRj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 08:17:39 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:55223 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbaC0MRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 08:17:37 -0400
X-AuditID: cbfee61a-b7fb26d00000724f-78-533416dfcb2e
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: mturquette@linaro.org
Cc: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        gregkh@linuxfoundation.org, linux@arm.linux.org.uk, robh+dt@kernel.org,
        grant.likely@linaro.org, mark.rutland@arm.com, galak@codeaurora.org,
        kyungmin.park@samsung.com, sw0312.kim@samsung.com,
        m.szyprowski@samsung.com, t.figa@samsung.com,
        linux-kernel@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC v3 0/2] clk: Support for DT assigned clock parents and rates
Date: Thu, 27 Mar 2014 13:16:17 +0100
Message-id: <1395922579-28547-1-git-send-email-s.nawrocki@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKLMWRmVeSWpSXmKPExsVy+t9jAd37YibBBnuOS1nMP3KO1aL/zUJW
	iwN/djBaNC9ez2ZxtukNu8Wmx9dYLS7vmsNmcfsyr8XaI3fZLZZev8hk8XTCRTaL1r1H2C0O
	v2lntZgx+SWbxfoZr1kc+D3WzFvD6NHS3MPmcbmvl8lj06pONo871/aweeyfu4bdY/OSeo++
	LasYPT5vkgvgjOKySUnNySxLLdK3S+DKuNk1i6XglHTFu+sf2RsYn4h0MXJySAiYSNw49psN
	whaTuHBvPZDNxSEksIhRovXKCRaQhJBAB5PEkRsJIDabgKFE79E+RhBbREBS4sHn6SwgDcwC
	7cwSa6dsAmsQFgiQOH/0NSuIzSKgKvF76xJmEJtXwE3i7N9GoA0cQNsUJOZMspnAyL2AkWEV
	o2hqQXJBcVJ6rqFecWJucWleul5yfu4mRnBgPpPawbiyweIQowAHoxIP7477RsFCrIllxZW5
	hxglOJiVRHhvC5sEC/GmJFZWpRblxxeV5qQWH2KU5mBREuc90GodKCSQnliSmp2aWpBaBJNl
	4uCUamBcd1ljq8iuLcfvdkQ5hSk+3hhb3qf98c9Ok67JmtvTnv3vVTrTHO320Sgy/Fae8B/v
	S59aDgbLKR/SY2uXNX/4xkVvkcQuC+upswweLEwWYnmt5bjZxFJ2Adc/66CNDTeYTGTuPhDv
	LK9rYj9subCngVODL03x+KTS2g8N+a2fV/FEXqj0sFViKc5INNRiLipOBADLnO/jSAIAAA==
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

I didn't add sorting of clocks depending on parentship relation when
setting the clock rates, it could be added in next iteration if it's
decided it's required.

Changes since v2:
 - code reordering to ensure there is no build errors, the clock
   configuration code moved to a separate file,
 - introduced an 'assigned-clocks' DT node which is supposed to contain
   clocks, clock-parents, clock-rates properties and be child node
   a clock provider node, and a code parsing it called from of_clk_init();
   It's for clocks which are not directly connected to consumer devices.
   An alternative would be to list such assigned clocks in 'clocks'
   property, along with "proper" parent clocks, but then there would
   be phandles in clocks property of a node pointing to itself and it
   would require proper handling in of_clock_init().
   I actually tried it but it looked a bit ugly and chose this time to
   use an extra subnode.

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

This series has been tested on ARM, on Exynos4412 Trats2 board, with
patch [1] applied. RFC v2 can be found at [2].

[1] https://lkml.org/lkml/2014/3/27/97
[2] https://lkml.org/lkml/2014/3/3/324

Sylwester Nawrocki (2):
  clk: Add function parsing arbitrary clock list DT property
  clk: Add handling of clk parent and rate assigned from DT

 .../devicetree/bindings/clock/clock-bindings.txt   |   26 ++++++
 drivers/base/dd.c                                  |    7 ++
 drivers/clk/Makefile                               |    1 +
 drivers/clk/clk-conf.c                             |   87 ++++++++++++++++++++
 drivers/clk/clk.c                                  |   10 ++-
 drivers/clk/clkdev.c                               |   25 +++++-
 include/linux/clk.h                                |    7 ++
 include/linux/clk/clk-conf.h                       |   19 +++++
 8 files changed, 177 insertions(+), 5 deletions(-)
 create mode 100644 drivers/clk/clk-conf.c
 create mode 100644 include/linux/clk/clk-conf.h

--
1.7.9.5

