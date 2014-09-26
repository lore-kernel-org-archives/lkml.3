Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186AbaIZC7T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 22:59:19 -0400
Received: from mga03.intel.com ([134.134.136.65]:3873 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752386AbaIZC7S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 22:59:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,602,1406617200"; 
   d="scan'208";a="579254792"
From: "Tan, Joshua Chu Yeaw" <joshua.chu.yeaw.tan@intel.com>
To: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: ASoC DPCM has issues when multiple FEs links to same type of codec.
Thread-Topic: ASoC DPCM has issues when multiple FEs links to same type of
 codec.
Thread-Index: Ac/ZNKDSMrJb2gw1RFifDBwq2bqGVA==
Date: Fri, 26 Sep 2014 02:56:55 +0000
Message-ID: <E8645821A2816A4380DAD4F80FFE7DB01BF2F2BB@PGSMSX104.gar.corp.intel.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.30.20.205]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

ALSA ASoC DPCM FE - BE connection doesn't handle the scenario when a machine driver has multiple FEs linking to same codec type. 

Let me use dummy codec as example codec:

	FE1 - BE1 (connected to dummy codec  instance #1)
	FE2 - BE2 (connected to dummy codec  instance #2)
	FE3 - BE3 (connected to dummy codec  instance #3)

DPCM will not be able to correctly identify the Back End from the 2nd pair onwards. 
This happens as the codec .stream_name is used 3 times to connect to different Back-Ends.

Say I am using the dummy codec that has a playback .stream_name "Dummy Playback" with 3 I2S AIF.

E.g. I have 3 BE dai links:
static struct snd_soc_dai_link xxx_dailink[] = {
	...
	{
		 .name = "I2S0-Codec",
		.be_id = 1,
		.cpu_dai_name = "i2s0-port",
		.platform_name = "xxx-platform",
		.no_pcm = 1,
		.codec_dai_name = "snd-soc-dummy-dai",
		.codec_name = "snd-soc-dummy",
	} 
	{
		.name = "I2S1-Codec",
		.be_id = 2,
		.cpu_dai_name = "i2s1-port",
		.platform_name = "xxx-platform",
		.no_pcm = 1,
		.codec_dai_name = "snd-soc-dummy-dai",
		.codec_name = "snd-soc-dummy",
	} 
	{
		.name = "I2S2-Codec",
		.be_id = 3,
		.cpu_dai_name = "i2s2-port",
		.platform_name = "xxx-platform",
		.no_pcm = 1,
		.codec_dai_name = "snd-soc-dummy-dai",
		.codec_name = "snd-soc-dummy",
	}

/*DAPM routing*/
static const struct snd_soc_dapm_route map[] = {
	{ "Dummy Playback", NULL, "I2S0 Tx"},
	{ "Dummy Playback", NULL, "I2S1 Tx"},
	{ "Dummy Playback", NULL, "I2S2 Tx"},
	...
}

The order of the DAI Link affects the connection of the codec stream name widget on a first come first serve basis,  in this case, first declared DAI link codec is used.
In soc-pcm.c, when dpcm_fe_dai_open tries to add paths for the 2nd(and later) FE, dpcm_add_paths function will always discover the "Dummy Playback" widget belonging to the back-end of the first DAI link and link it incorrectly.

1. dpcm_add_paths() finds "Dummy Playback" is a snd_soc_dapm_dai_in type, and calls dpcm_get_be()

	1101	 static int dpcm_add_paths(struct snd_soc_pcm_runtime *fe, int stream,
	1102       	  struct snd_soc_dapm_widget_list **list_)
	... 
	1120                 	/* is there a valid BE rtd for this widget */
	1121                 	be = dpcm_get_be(card, list->widgets[i], stream); 

2. The dpcm_get_be will traverse the list for "Dummy Playback" and return the first back end found.
Line 994 below always finds that I2S0-Codec link matches this condition and will not proceed further to match I2S1-Codec

990         if (stream == SNDRV_PCM_STREAM_PLAYBACK) {
991                 for (i = 0; i < card->num_links; i++) {
992                         be = &card->rtd[i];
993 
994                         if (!be->dai_link->no_pcm)	
995                                 continue;
996 
997                         if (be->cpu_dai->playback_widget == widget ||
998                                 be->codec_dai->playback_widget == widget)
999                                 return be;
1000                 }
1001         } else {    --> Same effect also happens in the capture path.


E.g. When I try to playback on the i2s1 (2nd playback device), the following fe-be link happens :
Widget = "I2S1 Tx", Back End = "I2S1-Codec"		--> This is the intended link.
Widget = "Dummy Playback", Back End = "I2S0-Codec" 	--> This is additional problematic link because the first discovered "Dummy Playback" is from the codec in the first DAI link.

This results in soc_pcm_open called twice in dpcm_be_dai_startup function; first for the first Back End (undesired), and then only the correct Back End 

Is it possible to add some instance id to the codec name, or some check on the intended FE-BE pairing? 


Regards,
Joshua

