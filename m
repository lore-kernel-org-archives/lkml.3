Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630Ab3DOIuv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 04:50:51 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:63120 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501Ab3DOIut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 04:50:49 -0400
MIME-Version: 1.0
X-Originating-IP: [114.39.99.165]
In-Reply-To: <CAFRkauDHn88Y8cAemTNVCXW6WUVqvFfhw1iY174nepNymiU8Nw@mail.gmail.com>
References: <1365424274.21989.2.camel@phoenix>
	<516BB444.7010508@stericsson.com>
	<CAFRkauDHn88Y8cAemTNVCXW6WUVqvFfhw1iY174nepNymiU8Nw@mail.gmail.com>
Date: Mon, 15 Apr 2013 16:50:45 +0800
Message-ID: <CAFRkauDhqwcHtJU_uBf8wMmKr8DohHZnU6DNPBnzZhTp9-eBfg@mail.gmail.com>
Subject: Re: [PATCH] regulator: ab8500: Fix get_mode for shared mode regulators
From: Axel Lin <axel.lin@ingics.com>
To: =?ISO-8859-1?Q?Bengt_J=F6nsson?= <bengt.g.jonsson@stericsson.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> My understanding is for shared mode regulators:
> It can be in LP mode only when *BOTH* are in LP mode.
> If only one of the regulator in HP mode, then *BOTH* should be in HP mode.
> Did I misunderstand something?

Let me put this issue this way:

Current code behavior:
get_mode() returns IDLE if only one lp_mode_req flag is true, but mode
register value is HP.

AB8540_LDO_ANAMIC1      AB8540_LDO_ANAMIC2      mode register
get_mode() returns
lp_mode_req=true        lp_mode_req=true        HP
REGULATOR_MODE_NORMAL
lp_mode_req=true        lp_mode_req=false       HP
REGULATOR_MODE_IDLE
lp_mode_req=false       lp_mode_req=true        HP
REGULATOR_MODE_IDLE
lp_mode_req=false       lp_mode_req=false       LP
REGULATOR_MODE_IDLE

with this path:
mode register value is consistent with get_mode().

AB8540_LDO_ANAMIC1      AB8540_LDO_ANAMIC2      mode register
get_mode() returns
lp_mode_req=true        lp_mode_req=true        HP
REGULATOR_MODE_NORMAL
lp_mode_req=true        lp_mode_req=false       HP
REGULATOR_MODE_NORMAL
lp_mode_req=false       lp_mode_req=true        HP
REGULATOR_MODE_NORMAL
lp_mode_req=false       lp_mode_req=false       LP
REGULATOR_MODE_IDLE
