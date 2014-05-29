Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933298AbaE2IP5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 04:15:57 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64455 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932560AbaE2IPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 04:15:54 -0400
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org
Cc: Zhang Rui <rui.zhang@intel.com>, linux-kernel@vger.kernel.org,
        amit.kachhap@gmail.com, edubezval@gmail.com, rjw@rjwysocki.net,
        linux-arm-kernel@lists.infradead.org, lenb@kernel.org
Subject: [PATCH v1 0/6] ACPI: thermal: Migrate cpufreq cooling to generic cpu_cooling layer
Date: Thu, 29 May 2014 13:45:28 +0530
Message-Id: <1401351334-11210-1-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since RFC:
* Moved the cooling state notification support to thermal core from cpu cooling
  as suggested by Eduardo.
* Used per cpu notifier structure in the cpufreq cooling implementation. This
  is a fix for race condition.
* One more comment from Eduardo was to take care when multiple listeners try to
  modify the cooling state. This is however not implemented in this patch series.
  One idea is to allow only 1 set type of clients and multiple get type of clients.
  The point to consider in these case is that cooling state management logic is now
  in control of client driver and thermal governor cooling state decisions can be
  overriden.
* Fixed other minor review comments and updated documentation section.

This patch adds notification support for those clients of cpu_cooling
APIs which may want to do something extra after receiving these
cpu_cooling events shown below. The notifier structure passed is of both Set/Get type.
The notfications events can be of the following type,

1. COOLING_SET_STATE_PRE
2. COOLING_SET_STATE_POST
3. COOLING_GET_CUR_STATE
4. COOLING_GET_MAX_STATE

The advantages of these notfications is to differentiate between different
P states in the cpufreq table and the cooling states. The clients of these
events may group few P states into 1 cooling states as done by ACPI .
Also some more cooling states can be enabled when the maximum of P state is
reached. In case of ACPI processor throttling are enabled when minimum
P-state is reached. Post notification events can be used for those cases.

All these changes are tested in samsung arndale(exynos5250) with Linaro ACPI
kernel along with few tweaks. However only cpu frequency scaling down is tested
for thermal cooling and throttling is untested as this feature is not supported
in H/W. But since the functionality is not modified so expecting the changes to
work in ACPI based platform also.  

Amit Daniel Kachhap (6):
  thermal: cpu_cooling: Fix the notification mechanism by using per cpu
    structure
  thermal: cpu_cooling: Support passing driver private data.
  thermal: thermal-core: Add notifications support for the cooling
    states
  thermal: cpu_cooling: Add support to find up/low frequency levels.
  thermal: thermal_core: Remove the max cooling limit check in
    registration
  ACPI: thermal: processor: Use the generic cpufreq infrastructure

